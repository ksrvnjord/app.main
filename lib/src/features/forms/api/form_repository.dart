/// Class to handle all the form related operations.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_question_answer.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class FormRepository {
  static Future<DocumentReference<FormAnswer>> upsertFormAnswer({
    required String question,
    required String? newValue, // Given answer.
    required FirestoreForm form,
    required DocumentReference<FirestoreForm> docRef,
    required WidgetRef ref,
  }) async {
    // PRECONDITIONS.
    final user = ref.read(currentUserNotifierProvider);
    if (user == null) {
      throw Exception('User is null');
    }

    if (DateTime.now().isAfter(form.openUntil)) {
      throw Exception('Form is closed');
    }

    // Read latest data from Firestore.
    final answerSnapshot = await ref.watch(formAnswerProvider(docRef).future);

    final docs = answerSnapshot.docs;
    // Document exists, so we update it.
    if (docs.isNotEmpty) {
      return _updateExistingFormAnswer(
        doc: docs.first,
        question: question,
        newValue: newValue,
      );
    }

    // No document found for the user, so we create a new one.
    return FormAnswer.firestoreConvert(docRef.path).add(FormAnswer(
      userId: user.identifier.toString(),
      answers: [
        FormQuestionAnswer(question: question, answer: newValue),
      ],
      answeredAt: DateTime.now(),
    ));
  }

  static Future<DocumentReference<FormAnswer>> _updateExistingFormAnswer({
    required QueryDocumentSnapshot<FormAnswer> doc,
    required String question,
    required String? newValue,
  }) async {
    final List<FormQuestionAnswer> formAnswers = doc.data().answers;

    final formQuestionAnswer = formAnswers.firstWhere(
      (a) => a.question == question,
      orElse: () => FormQuestionAnswer(question: question, answer: newValue),
    );

    formQuestionAnswer.answer = newValue;

    if (!formAnswers.contains(formQuestionAnswer)) {
      formAnswers.add(formQuestionAnswer);
    }

    await doc.reference.update({
      'answers': formAnswers.map((answer) => answer.toJson()).toList(),
      'answeredAt': Timestamp.now(),
    });

    return doc.reference;
  }
}
