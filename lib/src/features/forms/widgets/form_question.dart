import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormQuestion extends ConsumerWidget {
  const FormQuestion({
    Key? key,
    required this.formQuestion,
    required this.form,
    required this.docRef,
    required this.formIsOpen,
  }) : super(key: key);

  final FirestoreFormQuestion formQuestion;

  final FirestoreForm form;

  final DocumentReference<FirestoreForm> docRef;

  final bool formIsOpen;

  // ignore: avoid-long-parameter-list
  _handleChangeOfFormAnswer({
    required String question,
    required String? newValue, // Given answer.
    required FirestoreForm f,
    required DocumentReference<FirestoreForm> d,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      // ignore: avoid-ignoring-return-values
      await FormRepository.upsertFormAnswer(
        question: formQuestion.label,
        newValue: newValue,
        form: f,
        docRef: d,
        ref: ref,
      );
    } on Exception catch (error) {
      if (!context.mounted) return;
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final type = formQuestion.type;

    final questionWidgets = <Widget>[
      Text(formQuestion.label, style: textTheme.titleLarge),
    ];

    final answerStream = ref.watch(formAnswerProvider(docRef));
    final formQuestionControllerProvider =
        StateNotifierProvider.autoDispose<FormQuestionController, FocusNode>(
      (ref) => FormQuestionController(),
    );

    // ignore: avoid-ignoring-return-values
    answerStream.when(
      // ignore: avoid-long-functions
      data: (data) {
        String? answerValue;
        if (data.docs.isNotEmpty) {
          // ignore: avoid-unsafe-collection-methods
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

            final answerNode = ref.watch(formQuestionControllerProvider);
            answerNode.addListener(() {
              if (!answerNode.hasFocus) {
                // ignore: avoid-ignoring-return-values
                _handleChangeOfFormAnswer(
                  question: formQuestion.label,
                  newValue: answer.text,
                  f: form,
                  d: docRef,
                  ref: ref,
                  context: context,
                );
              }
            });

            questionWidgets.add(
              TextFormField(
                controller: answer,
                onFieldSubmitted: (String? value) => _handleChangeOfFormAnswer(
                  question: formQuestion.label,
                  newValue: value,
                  f: form,
                  d: docRef,
                  ref: ref,
                  context: context,
                ),
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
              onChanged: (String? value) => _handleChangeOfFormAnswer(
                question: formQuestion.label,
                newValue: value,
                f: form,
                d: docRef,
                ref: ref,
                context: context,
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

class FormQuestionController extends StateNotifier<FocusNode> {
  FormQuestionController() : super(FocusNode());

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}
