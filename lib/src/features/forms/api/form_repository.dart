import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/firestorm_filler_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_question_answer.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FormRepository {
  static Future<DocumentReference<FormAnswer>> upsertFormAnswerDeprecated({
    required String question,
    int? questionId,
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
      questionId: questionId,
      answer: newValue,
    );

    // Document exists, so we update it.
    return docs.isNotEmpty
        ? _updateExistingFormAnswerDeprecated(
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
            isCompleted: checkIfFormIsCompletedDeprecated(
              //TODO questionUpdate: remove deprecated
              form: form,
              formAnswers: [formQuestionAnswer],
            ),
          ));
  }

  static Future<DocumentReference<FormAnswer>> upsertFormAnswer({
    required String question,
    int? questionId,
    required List<String>? newValue, // Given answer.
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
      questionId: questionId,
      answerList: newValue,
    );

    // Document exists, so we update it.
    return docs.isNotEmpty
        ? _updateExistingFormAnswer(
            // ignore: avoid-unsafe-collection-methods
            doc: docs.first,
            questionId: questionId,
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

  static Future<bool> createFormImages({
    required String formId,
    required Map<int, FirestoreFormFillerNotifier> fillers,
  }) async {
    final storage = FirebaseStorage.instance;

    try {
      for (final fillerNotifier in fillers.values) {
        final filler = fillerNotifier.value;

        if (filler.hasImage && filler.image != null && filler.imageChanged) {
          final fileBytes = await filler.image!.readAsBytes();

          final storageRef = storage.ref().child(
              '$firestoreFormCollectionName/$formId/fillers/${filler.id}');

          await storageRef.putData(fileBytes);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<DocumentReference<FirestoreForm>> createOrUpdateForm({
    required String? id,
    required FirestoreForm form,
  }) async {
    if (id != null) {
      await FirestoreForm.firestoreConvert.doc(id).set(form);
      // Return the reference so you can still use it
      return FirestoreForm.firestoreConvert.doc(id);
    } else {
      return await FirestoreForm.firestoreConvert.add(form);
    }
  }

  static deleteForm(String path) async {
    await FirebaseFirestore.instance.doc(path).delete();
  }

  static Future<void> deleteMyFormAnswer(String path) async {
    await FirebaseFirestore.instance.doc(path).delete();
  }

  static bool checkIfFormIsCompletedDeprecated({
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
          var filledInRequiredQuestion =
              // ignore: avoid-non-null-assertion
              myAnswer.answer != null && myAnswer.answer!.isNotEmpty;
          if (question.type == FormQuestionType.multipleChoice) {
            filledInRequiredQuestion =
                // ignore: avoid-non-null-assertion
                myAnswer.answer != null && !(myAnswer.answer! == "[]");
          }
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

  static bool checkIfFormIsCompleted({
    required FirestoreForm form,
    required List<FormQuestionAnswer> formAnswers,
  }) {
    for (final entry in form.questionsMap.entries) {
      final questionId = entry.key;
      final question = entry.value;
      if (question.isRequired) {
        try {
          // ignore: avoid-unsafe-collection-methods
          final myAnswer = formAnswers.firstWhere(
            (a) => a.questionId == questionId,
          );
          var filledInRequiredQuestion =
              // ignore: avoid-non-null-assertion
              myAnswer.answerList != null && myAnswer.answerList!.isNotEmpty;
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

  static Future<DocumentReference<FormAnswer>>
      _updateExistingFormAnswerDeprecated({
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

  static Future<DocumentReference<FormAnswer>> _updateExistingFormAnswer({
    required QueryDocumentSnapshot<FormAnswer> doc,
    required int? questionId,
    required List<String>? newValue,
    required FirestoreForm form,
  }) async {
    final formAnswers = doc.data().answers;

    final formQuestionAnswer = formAnswers.firstWhere(
      (a) => a.questionId == questionId,
      orElse: () =>
          FormQuestionAnswer(questionId: questionId, answerList: newValue),
    );

    formQuestionAnswer.answerList = newValue;

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

  static Future<DocumentReference<FormAnswer>> makeFormAnswerDefinitive({
    required DocumentReference<FormAnswer> docRef,
  }) async {
    await docRef.update(
      {
        'definitiveAnswerHasBeenGiven': true,
      },
    );

    return docRef;
  }

  static Future<void> updateOpenUntilTime(
    DocumentReference<FirestoreForm> docRef,
    DateTime newOpenUntil,
  ) async {
    await docRef.update({'openUntil': newOpenUntil});
  }

  static Future<String?> getFillerImageUrl(String formId, int fillerId) async {
    final storage = FirebaseStorage.instance;
    final ref =
        storage.ref('$firestoreFormCollectionName/$formId/fillers/$fillerId');

    try {
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Could not fetch image for filler $fillerId: $e');
      return null;
    }
  }

  /// Optionally, download the image as an XFile
  static Future<XFile?> downloadFillerImage(String formId, int fillerId) async {
    final url = await FormRepository.getFillerImageUrl(formId, fillerId);
    if (url == null) return null;

    if (kIsWeb) {
      return XFile(url);
    } else {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/filler_$fillerId.jpg');
      await FirebaseStorage.instance.refFromURL(url).writeToFile(file);
      return XFile(file.path);
    }
  }
}
