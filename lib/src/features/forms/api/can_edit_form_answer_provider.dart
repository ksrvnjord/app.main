import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';

// ignore: prefer-static-class
final canRemoveFormAnswerProvider = StreamProvider.autoDispose
    .family<bool, DocumentReference<FormAnswer>>((ref, answerDocRef) {
  // Get the answer snapshot for this specific document
  final answerSnapStream = answerDocRef.snapshots();

  // Check if the user can edit this answer
  final formDocRef = answerDocRef.parent.parent!.withConverter<FirestoreForm>(
    fromFirestore: (snap, _) => FirestoreForm.fromJson(snap.data()!),
    toFirestore: (form, _) => form.toJson(),
  );

  final canEditFormVal = ref.watch(canEditFormAnswerProvider(formDocRef));

  return answerSnapStream.asyncMap((answerSnap) {
    final hasAnswer = answerSnap.exists;
    final isDefinitive =
        hasAnswer ? answerSnap.data()!.definitiveAnswerHasBeenGiven : false;

    // canEditFormVal is AsyncValue<bool>, handle with when
    return canEditFormVal.when(
      data: (canEdit) => hasAnswer && canEdit && !isDefinitive,
      loading: () => false,
      error: (_, __) => false,
    );
  });
});

// ignore: prefer-static-class
final canEditFormAnswerProvider = StreamProvider.autoDispose
    .family<bool, DocumentReference<FirestoreForm>>((ref, formRef) {
  final form = ref.watch(formProvider(formRef));

  return form.when(
    data: (form) {
      final formIsOpen = form.data()?.openUntil.isAfter(DateTime.now()) == true;

      // Add a timer that updates the formIsOpen value when the form is closed.
      if (formIsOpen) {
        unawaited(
          // ignore: prefer-async-await
          Future.delayed(
            // ignore: avoid-non-null-assertion
            form.data()!.openUntil.difference(DateTime.now()),
          ).then((_) => ref.invalidateSelf()),
        );
      }

      return Stream.value(formIsOpen);
    },
    error: (error, _) => throw error,
    loading: () => Stream.value(false),
  );
});
