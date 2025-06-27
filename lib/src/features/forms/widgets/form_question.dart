// ignore_for_file: prefer-extracting-function-callbacks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/date_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_image_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/multiple_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormQuestion extends ConsumerStatefulWidget {
  const FormQuestion({
    super.key,
    required this.formQuestion,
    required this.form,
    required this.docRef,
    required this.formIsOpen,
    this.withoutBorder = false,
    this.showAdditionalSaveButton = true, // TODO: This should be false/removed
  });

  final FirestoreFormQuestion formQuestion;

  final FirestoreForm form;

  final DocumentReference<FirestoreForm> docRef;

  final bool formIsOpen;

  final bool withoutBorder;

  final bool showAdditionalSaveButton; // New parameter

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

  Future<void> _handleChangeOfFormAnswer({
    required String question,
    required String? newValue,
    required FirestoreForm f,
    required DocumentReference<FirestoreForm> d,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final currentState = _formKey.currentState;
    if (currentState?.validate() == false) {
      return;
    }

    try {
      await FormRepository.upsertFormAnswer(
        question: question,
        newValue: newValue,
        form: f,
        docRef: d,
        ref: ref,
      );
    } on Exception catch (error) {
      if (!context.mounted) return;
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

    const horizontalPaddingCard = 8.0;

    const verticalPaddingCard = 2.0;

    final type = widget.formQuestion.type;

    final questionWidgets = <Widget>[
      Text(widget.formQuestion.title, style: textTheme.titleLarge),
      if (widget.formQuestion.isRequired) const Text('Verplicht'),
    ];

    final answerStream = ref.watch(formAnswerProvider(widget.docRef));

    answerStream.when(
      data: (data) {
        String? answerValue;
        if (data.docs.isNotEmpty) {
          final formAnswers = data.docs.first.data().answers;
          for (final entry in formAnswers) {
            if (entry.questionTitle == widget.formQuestion.title) {
              //TODO questionMigration: match op id
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: answer,
                        focusNode: _focusNode,
                        maxLines: null,
                        onSaved: (String? value) => _handleChangeOfFormAnswer(
                          question: widget.formQuestion.title,
                          newValue: value,
                          f: widget.form,
                          d: widget.docRef,
                          ref: ref,
                          context: context,
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Antwoord kan niet leeg zijn.'
                            : null,
                        enabled: widget.formIsOpen,
                      ),
                    ),
                    if (widget.showAdditionalSaveButton)
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.save();
                        },
                        child: const Text("Opslaan"),
                      ),
                  ],
                ),
              ),
            );
            break;

          case FormQuestionType.singleChoice:
            questionWidgets.add(SingleChoiceWidget(
              initialValue: answerValue,
              formQuestion: widget.formQuestion,
              onChanged: (String? value) => _handleChangeOfFormAnswer(
                question: widget.formQuestion.title,
                newValue: answerValue == value ? null : value,
                f: widget.form,
                d: widget.docRef,
                ref: ref,
                context: context,
              ),
              formIsOpen: widget.formIsOpen,
            ));
            break;

          case FormQuestionType.multipleChoice:
            final values = answerValue == null || answerValue == '[]'
                ? <String>[]
                : answerValue
                    .substring(1, answerValue.length - 1)
                    .split(r';')
                    .map(Uri.decodeComponent)
                    .toList();

            questionWidgets.add(MultipleChoiceWidget(
              initialValues: values,
              formQuestion: widget.formQuestion,
              onChanged: (List<String> newValues) => _handleChangeOfFormAnswer(
                question: widget.formQuestion.title,
                newValue: '[${newValues.map(Uri.encodeComponent).join(r';')}]',
                f: widget.form,
                d: widget.docRef,
                ref: ref,
                context: context,
              ),
              formIsOpen: widget.formIsOpen,
            ));
            break;

          case FormQuestionType.image:
            questionWidgets.add(FormImageWidget(
              docId: widget.docRef.id,
              questionName: widget.formQuestion.title,
              formIsOpen: widget.formIsOpen,
              onChanged: (String? value) => _handleChangeOfFormAnswer(
                question: widget.formQuestion.title,
                newValue: value,
                f: widget.form,
                d: widget.docRef,
                ref: ref,
                context: context,
              ),
            ));
            break;

          case FormQuestionType.date:
            DateTime? answerValueDateTime;
            try {
              answerValueDateTime = DateTime.parse(answerValue!).toLocal();
            } catch (e) {
              answerValueDateTime = null;
            }

            questionWidgets.add(
              DateChoiceWidget(
                answerValueDateTime: answerValueDateTime,
                question: widget.formQuestion,
                formIsOpen: widget.formIsOpen,
                onChanged: (String? value) => _handleChangeOfFormAnswer(
                  question: widget.formQuestion.title,
                  newValue: value,
                  f: widget.form,
                  d: widget.docRef,
                  ref: ref,
                  context: context,
                ),
              ),
            );

          case FormQuestionType.unsupported:
            questionWidgets.add(Card(
              color: colorScheme.errorContainer,
              elevation: 0,
              margin: EdgeInsets.zero,
              child: Text(
                      "Jouw versie ondersteunt niet dit vraagtype. Update de app.")
                  .padding(
                horizontal: horizontalPaddingCard,
                vertical: verticalPaddingCard,
              ),
            ));

          default:
            return const ErrorCardWidget(
              errorMessage: 'Onbekend type vraag',
            );
        }
      },
      error: (error, stackTrace) {
        return ErrorCardWidget(errorMessage: error.toString());
      },
      loading: () {
        return const CircularProgressIndicator.adaptive();
      },
    );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: widget.withoutBorder
            ? null
            : Border.all(color: colorScheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: questionWidgets.toColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
