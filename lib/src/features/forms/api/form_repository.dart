/// Class to handle all the form related operations.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_question_answer.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:styled_widget/styled_widget.dart';

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
            answers: [FormQuestionAnswer(question: question, answer: newValue)],
            answeredAt: DateTime.now(),
            completed: true, // TODO: Add logic.
          ));
  }

  static Future<DocumentReference<FirestoreForm>> upsertCreateForm({
    required FirestoreForm form,
  }) async {
    return await FirestoreForm.firestoreConvert.add(form);
  }

  static deleteForm(String path) async {
    await FirebaseFirestore.instance.doc(path).delete();
  }

  static Future<void> deleteMyFormAnswer(String path) async {
    await FirebaseFirestore.instance.doc(path).delete();
  }

  static Future<DocumentReference<FormAnswer>> _updateExistingFormAnswer({
    required QueryDocumentSnapshot<FormAnswer> doc,
    required String question,
    required String? newValue,
    required FirestoreForm form,
  }) async {
    final formAnswers = doc.data().answers;

    final formQuestionAnswer = formAnswers.firstWhere(
      (a) => a.question == question,
      orElse: () => FormQuestionAnswer(question: question, answer: newValue),
    );

    formQuestionAnswer.answer = newValue;

    formQuestionAnswer.isRequiredAndCompleted = form.questions
            .firstWhere(
              (q) => q.label == question,
              orElse: () => throw Exception('Question not found'),
            )
            .isRequired
        ? newValue != null
        : false;

    if (!formAnswers.contains(formQuestionAnswer)) {
      formAnswers.add(formQuestionAnswer);
    }

    double countRequiredQuestions = 0;
    double countCompletedRequiredQuestions = 0;
    for (var question in form.questions) {
      if (question.isRequired) {
        countRequiredQuestions++;
      }
    }
    for (var answer in formAnswers) {
      print('answer: ${answer.isRequiredAndCompleted}');
      if (answer.isRequiredAndCompleted) {
        countCompletedRequiredQuestions++;
      }
    }

    print('formAnswers: ${newValue == null}');
    print('questionAnswers: ${formAnswers.length}');
    print('countRequiredQuestions: $countRequiredQuestions');
    print('countCompletedRequiredQuestions: $countCompletedRequiredQuestions');

    await doc.reference.update({
      'answers': formAnswers.map((answer) => answer.toJson()).toList(),
      'answeredAt': Timestamp.now(),
      'completed': countRequiredQuestions ==
          countCompletedRequiredQuestions, // TODO: Add logic.
    });

    return doc.reference;
  }
}
