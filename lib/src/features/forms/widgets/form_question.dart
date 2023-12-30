import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_question_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormQuestion extends ConsumerWidget {
  const FormQuestion({
    Key? key,
    required this.formQuestion,
    required this.formPath,
    required this.form,
    required this.docRef,
    required this.formIsOpen,
  }) : super(key: key);

  final FirestoreFormQuestion formQuestion;

  final String formPath;

  final FirestoreForm form;

  final DocumentReference<FirestoreForm> docRef;

  final bool formIsOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final type = formQuestion.type;

    final questionWidgets = [
      Text(formQuestion.label, style: textTheme.titleLarge),
    ];

    final answerStream = ref.watch(formAnswerProvider(docRef));

    // ignore: avoid-ignoring-return-values
    answerStream.when(
      data: (data) {
        String? answerValue;

        if (data.docs.isNotEmpty) {
          final formAnswers = data.docs.first.data().answers;

          for (final entry in formAnswers) {
            if (entry.question == formQuestion.label) {
              answerValue = entry.answer;
            }
          }
        }

        switch (type) {
          case FormQuestionType.text:
            TextEditingController answer =
                TextEditingController(text: answerValue);

            questionWidgets.add(
              TextFormField(
                controller: answer,
                onFieldSubmitted: (String? value) => {
                  FormRepository.upsertFormAnswer(
                    question: formQuestion.label,
                    newValue: value,
                    form: form,
                    docRef: docRef,
                    ref: ref,
                  ),
                },
                validator: ((value) => (value == null || value.isEmpty)
                    ? 'Antwoord kan niet leeg zijn.'
                    : null),
                enabled: formIsOpen,
              ),
            );
            break;

          case FormQuestionType.singleChoice:
            questionWidgets.add(SingleChoiceWidget(
              initialValue: answerValue,
              formQuestion: formQuestion,
              form: form,
              docRef: docRef,
              ref: ref,
              onChanged: (String? value) => FormRepository.upsertFormAnswer(
                question: formQuestion.label,
                newValue: value,
                form: form,
                docRef: docRef,
                ref: ref,
              ),
              formIsOpen: formIsOpen,
            ));
            break;

          default:
            return const ErrorCardWidget(
              errorMessage: 'Onbekend type vraag',
            );
        }
      },
      error: (error, stackTrace) {
        return const ErrorCardWidget(errorMessage: 'Er is iets misgegaan');
      },
      loading: () {
        return const CircularProgressIndicator.adaptive();
      },
    );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: questionWidgets.toColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
