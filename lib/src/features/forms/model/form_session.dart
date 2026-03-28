import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';

class FormSession {
  FormSession({
    required this.formDoc,
    required this.answerDocRef,
    required this.user,
    this.prefillSnapshot,
  });

  final DocumentSnapshot<FirestoreForm> formDoc;

  /// Firestore doc where answers will be written
  final DocumentReference<FormAnswer>? answerDocRef;

  final User user;

  /// Optional previous answers for prefill
  /// Only used if ignoreFilledInForm == false
  final QuerySnapshot<FormAnswer>? prefillSnapshot;
}

Future<FormSession> createSession({
  required DocumentSnapshot<FirestoreForm> formDoc,
  required bool ignoreFilledInForm,
  required Ref ref,
}) async {
  QuerySnapshot<FormAnswer>? latestAnswer;

  if (!ignoreFilledInForm) {
    // optional one-time fetch for prefill (can be null)
    latestAnswer = await ref.read(formAnswerProvider(formDoc.reference).future);
  }

  // Determine the answer document
  final docRef = ignoreFilledInForm
      ? formDoc.reference
          .collection('answers')
          .withConverter<FormAnswer>(
            fromFirestore: (snap, _) => FormAnswer.fromJson(snap.data()!),
            toFirestore: (answer, _) => answer.toJson(),
          )
          .doc()
      : (latestAnswer?.docs.isNotEmpty == true
          ? latestAnswer!.docs.first.reference
          : formDoc.reference
              .collection('answers')
              .withConverter<FormAnswer>(
                fromFirestore: (snap, _) => FormAnswer.fromJson(snap.data()!),
                toFirestore: (answer, _) => answer.toJson(),
              )
              .doc());

  final user = ref.read(currentUserNotifierProvider);
  if (user == null) {
    throw Exception('User is null');
  }

  return FormSession(
    formDoc: formDoc,
    answerDocRef: docRef,
    user: user,
    prefillSnapshot: ignoreFilledInForm ? null : latestAnswer,
  );
}
