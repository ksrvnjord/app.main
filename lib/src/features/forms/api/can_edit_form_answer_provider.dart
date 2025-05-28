import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';

// ignore: prefer-static-class
final canRemoveFormAnswerProvider = StreamProvider.autoDispose
    .family<bool, DocumentReference<FirestoreForm>>((ref, formRef) {
  final formAnswerVal = ref.watch(formAnswerProvider(formRef));
  final canEditFormVal = ref.watch(canEditFormAnswerProvider(formRef));

  return formAnswerVal.when(
    data: (answers) => canEditFormVal.when(
      data: (canEditForm) {
        final hasAnswer = answers.docs.isNotEmpty;

        return Stream.value(hasAnswer && canEditForm);
      },
      error: (error, _) => throw error,
      loading: () => Stream.value(false),
    ),
    error: (error, _) => throw error,
    loading: () => Stream.value(false),
  );
});

// ignore: prefer-static-class
final canEditFormAnswerProvider = StreamProvider.autoDispose
    .family<bool, DocumentReference<FirestoreForm>>((ref, formRef) {
  final form = ref.watch(formProvider(formRef));

  return form.when(
    data: (form) {
      final formIsNotExpired = form.data()?.formClosingTimeIsInFuture == true;

      // Add a timer that updates the formIsNotExpired value when the form is closed.
      if (formIsNotExpired) {
        unawaited(
          // ignore: prefer-async-await
          Future.delayed(
            // ignore: avoid-non-null-assertion
            form.data()!.openUntil.difference(DateTime.now()),
          ).then((_) => ref.invalidateSelf()),
        );
      }

      return Stream.value(formIsNotExpired);
    },
    error: (error, _) => throw error,
    loading: () => Stream.value(false),
  );
});
