import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/forms_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';

final shouldShowSaveButtonProvider = StreamProvider.autoDispose
    .family<bool, DocumentReference<FirestoreForm>>((ref, formRef) {
  final formAsync = ref.watch(formProvider(formRef));
  final formAnswerAsync = ref.watch(formAnswerProvider(formRef));

  return formAsync.when(
    data: (form) => formAnswerAsync.when(
      data: (answers) {
        final hasAnswer = answers.docs.isNotEmpty;
        if (!hasAnswer) return Stream.value(false);

        final answerData = answers.docs.first.data();
        final isCompleted = answerData.isCompleted;
        final isDefinitive = answerData.definitiveAnswerHasBeenGiven;
        final formIsUnretractable =
            form.data()?.formAnswersAreUnretractable ?? false;

        final show = formIsUnretractable && isCompleted && !isDefinitive;
        return Stream.value(show);
      },
      error: (error, _) => throw error,
      loading: () => Stream.value(false),
    ),
    error: (error, _) => throw error,
    loading: () => Stream.value(false),
  );
});
