import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_question_answer.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';

// ignore: prefer-static-class
void upsertFormAnswer({
  required String? value, // Given answer.
  required String question,
  required DocumentSnapshot<FirestoreForm> formDoc,
  required WidgetRef ref,
}) async {
  final answerSnapshot =
      await ref.watch(formAnswerProvider(formDoc.reference).future);

  var userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  final CollectionReference<FormAnswer> collectionRef = FirebaseFirestore
      .instance
      .collection('${formDoc.reference.path}/answers')
      .withConverter(
        fromFirestore: (snapshot, _) =>
            FormAnswer.fromJson(snapshot.data() ?? {}),
        toFirestore: (answer, _) => answer.toJson(),
      );

  final FirestoreForm? form = formDoc.data();
  if (form == null) {
    throw Exception('Form is null');
  }

  if (DateTime.now().isAfter(form.openUntil)) {
    throw Exception('Form is closed');
  }

  final userSnapshot = ref.watch(currentfirestoreUserStreamProvider);
  final currentUser = userSnapshot.value?.docs.first.data();
  if (currentUser == null) {
    throw Exception('Firestore User is null');
  }

  try {
    if (answerSnapshot.docs.isNotEmpty) {
      final formAnswers =
          // ignore: prefer-moving-to-variable
          answerSnapshot.docs.first.data().answers;
      bool found = false;
      // Hebben we een antwoord op deze vraag?
      // ignore: avoid-non-null-assertion
      for (var i = 0; i < formAnswers!.length; i++) {
        if (formAnswers[i].question == question) {
          formAnswers[i].answer = value;
          found = true;
          break;
        }
      }

      if (!found) {
        formAnswers.add(FormQuestionAnswer(question: question, answer: value));
      }

      // ignore: prefer-moving-to-variable
      answerSnapshot.docs.first.reference.update({
        'answers': formAnswers.map((answer) => answer.toJson()).toList(),
        'answeredAt': Timestamp.now(),
      });

      // Document exists, so we update it.
      debugPrint("Form answer updated for user: $userId");
    } else {
      // There is no document for this user, so create one.
      List<FormQuestionAnswer> formAnswer = [
        FormQuestionAnswer(question: question, answer: value),
      ];
      // No document found for the user, so we create a new one.
      // ignore: avoid-ignoring-return-values
      await collectionRef.add(FormAnswer(
        userId: userId,
        answers: formAnswer,
        answeredAt: DateTime.now(),
        // User can't be null if using form feature.
        // ignore: avoid-non-null-assertion
        allergies:
            form.formName.contains("Eten") ? currentUser.allergies : null,
      ));
      debugPrint("Form answer created for user: $userId.");
    }
  } catch (error) {
    debugPrint("Error upserting form answer: $error");
  }
}
