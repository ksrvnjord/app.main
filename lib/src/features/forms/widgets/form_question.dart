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

class FormQuestion extends ConsumerStatefulWidget {
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

  @override
  createState() => _FormQuestionState();
}

class _FormQuestionState extends ConsumerState<FormQuestion> {
  final _focusNode = FocusNode(debugLabel: "FormQuestionState_textfield");
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _formKey.currentState?.save();
      }
    });
  }

  // ignore: avoid-long-parameter-list
  Future<void> _handleChangeOfFormAnswer({
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
        question: widget.formQuestion.label,
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
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final type = widget.formQuestion.type;

    final questionWidgets = <Widget>[
      Text(widget.formQuestion.label, style: textTheme.titleLarge),
    ];

    final answerStream = ref.watch(formAnswerProvider(widget.docRef));

    // ignore: avoid-ignoring-return-values
    answerStream.when(
      // ignore: avoid-long-functions
      data: (data) {
        String? answerValue;
        if (data.docs.isNotEmpty) {
          // ignore: avoid-unsafe-collection-methods
          final formAnswers = data.docs.first.data().answers;
          for (final entry in formAnswers) {
            if (entry.question == widget.formQuestion.label) {
              answerValue = entry.answer;
            }
          }
        }
        switch (type) {
          case FormQuestionType.text:
            TextEditingController answer =
                TextEditingController(text: answerValue);

            questionWidgets.add(
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: answer,
                  focusNode:
                      _focusNode, // The focus node controls when to save.
                  // ignore: avoid-async-call-in-sync-function
                  onSaved: (String? value) => _handleChangeOfFormAnswer(
                    question: widget.formQuestion.label,
                    newValue: value,
                    f: widget.form,
                    d: widget.docRef,
                    ref: ref,
                    context: context,
                  ),
                  validator: ((value) => (value == null || value.isEmpty)
                      ? 'Antwoord kan niet leeg zijn.'
                      : null),
                  enabled: widget.formIsOpen,
                ),
              ),
            );
            break;

          case FormQuestionType.singleChoice:
            questionWidgets.add(SingleChoiceWidget(
              initialValue: answerValue,
              formQuestion: widget.formQuestion,
              // ignore: avoid-async-call-in-sync-function
              onChanged: (String? value) => _handleChangeOfFormAnswer(
                question: widget.formQuestion.label,
                newValue: value,
                f: widget.form,
                d: widget.docRef,
                ref: ref,
                context: context,
              ),
              formIsOpen: widget.formIsOpen,
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
