import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_filler.dart';
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

    final formQuestionAnswer = FormQuestionAnswer(
      questionTitle: question,
      answer: newValue,
    );

    // Document exists, so we update it.
    return docs.isNotEmpty
        ? _updateExistingFormAnswer(
            // ignore: avoid-unsafe-collection-methods
            doc: docs.first,
            question: question,
            newValue: newValue,
            form: form,
          )
        : FormAnswer.firestoreConvert(docRef.path).add(FormAnswer(
            userId: user.identifier.toString(),
            answers: [formQuestionAnswer],
            answeredAt: Timestamp.now(),
            isCompleted: checkIfFormIsCompleted(
              form: form,
              formAnswers: [formQuestionAnswer],
            ),
          ));
  }

  static Future<DocumentReference<FirestoreForm>> createForm({
    required FirestoreForm form,
  }) async {
    return await FirestoreForm.firestoreConvert.add(form);
  }

  static Future<bool> createFormImages(
      {required String formId,
      required Map<int, FirestoreFormFiller> fillers}) async {
    final storage = FirebaseStorage.instance;
    try {
      for (final filler in fillers.values) {
        if (filler.hasImage && filler.image != null) {
          final fileBytes = await filler.image!.readAsBytes();

          final storageRef = storage.ref().child(
              '$firestoreFormCollectionName/$formId/fillers/${filler.id}');

          await storageRef.putData(
            fileBytes,
          );
          // ignore: empty_catches
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static deleteForm(String path) async {
    await FirebaseFirestore.instance.doc(path).delete();
  }

  static Future<void> deleteMyFormAnswer(String path) async {
    await FirebaseFirestore.instance.doc(path).delete();
  }

  static bool checkIfFormIsCompleted({
    required FirestoreForm form,
    required List<FormQuestionAnswer> formAnswers,
  }) {
    for (final question in form.questions) {
      if (question.isRequired) {
        try {
          // ignore: avoid-unsafe-collection-methods
          final myAnswer = formAnswers.firstWhere(
            (a) => a.questionTitle == question.title,
          );
          final filledInRequiredQuestion =
              // ignore: avoid-non-null-assertion
              myAnswer.answer != null && myAnswer.answer!.isNotEmpty;
          if (!filledInRequiredQuestion) {
            return false;
          }
        } catch (error, _) {
          // Answer not found for required question.
          return false;
        }
      }
    }

    return true;
  }

  static Future<DocumentReference<FormAnswer>> _updateExistingFormAnswer({
    required QueryDocumentSnapshot<FormAnswer> doc,
    required String question,
    required String? newValue,
    required FirestoreForm form,
  }) async {
    final formAnswers = doc.data().answers;

    final formQuestionAnswer = formAnswers.firstWhere(
      (a) => a.questionTitle == question,
      orElse: () =>
          FormQuestionAnswer(questionTitle: question, answer: newValue),
    );

    formQuestionAnswer.answer = newValue;

    if (!formAnswers.contains(formQuestionAnswer)) {
      formAnswers.add(formQuestionAnswer);
    }

    final isCompleted =
        checkIfFormIsCompleted(form: form, formAnswers: formAnswers);

    await doc.reference.update({
      'answers': formAnswers.map((answer) => answer.toJson()).toList(),
      'answeredAt': Timestamp.now(),
      FormAnswer.isCompletedJSONKey: isCompleted,
    });

    return doc.reference;
  }

  static Future<void> removeDraftStatus(
      DocumentReference<FirestoreForm> docRef) async {
    await docRef.update({'isDraft': false});
  }
}
