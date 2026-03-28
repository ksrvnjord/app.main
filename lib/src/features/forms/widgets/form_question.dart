import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_answer_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_session_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/shoud_show_save_button_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_session.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/date_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/form_image_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/multiple_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/single_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormQuestion extends ConsumerStatefulWidget {
  const FormQuestion({
    super.key,
    required this.session,
    required this.formQuestion,
    this.questionId,
    required this.userCanEditForm,
    this.withoutBorder = false,
    this.showAdditionalSaveButton = true,
  });

  final FormSession session;
  final FirestoreFormQuestion formQuestion;
  final int? questionId;
  final bool userCanEditForm;
  final bool withoutBorder;
  final bool showAdditionalSaveButton;

  @override
  ConsumerState<FormQuestion> createState() => _FormQuestionState();
}

class _FormQuestionState extends ConsumerState<FormQuestion> {
  final _focusNode = FocusNode(debugLabel: "FormQuestion_textfield");
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
    int? questionId,
    required List<String>? newValue,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final currentState = _formKey.currentState;
    if (currentState?.validate() == false) return;

    final user = ref.read(currentUserNotifierProvider);
    if (user == null) {
      throw Exception('User is null');
    }

    try {
      await FormRepository.upsertFormAnswerAtDocRef(
          userId: user.identifierString,
          questionId: questionId,
          newValue: newValue,
          form: widget.session.formDoc.data()!,
          answerDocRef: widget.session.answerDocRef!);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const horizontalPaddingCard = 8.0;
    const verticalPaddingCard = 2.0;

    final form = widget.session.formDoc.data();
    if (form == null) {
      return const ErrorCardWidget(errorMessage: 'Formulier niet gevonden');
    }

    final type = widget.formQuestion.type;
    final questionId = widget.questionId;
    final questionWidgets = <Widget>[
      Text(widget.formQuestion.title, style: textTheme.titleLarge),
      if (widget.formQuestion.isRequired) const Text('Verplicht'),
    ];

    // Safe access to the user's existing answer
    List<String>? answerValue;
    if (widget.session.prefillSnapshot?.docs.isNotEmpty == true) {
      final answers = widget.session.prefillSnapshot!.docs.first.data().answers;
      for (final entry in answers) {
        if (form.isV2) {
          if (entry.questionId == widget.formQuestion.id) {
            answerValue = entry.answerList;
          }
        } else {
          if (entry.questionTitle == widget.formQuestion.title) {
            answerValue = [entry.answer ?? ""];
          }
        }
      }
    }

    final answerIsDefinitive =
        widget.session.prefillSnapshot?.docs.isNotEmpty == true
            ? widget.session.prefillSnapshot!.docs.first
                .data()
                .definitiveAnswerHasBeenGiven
            : false;

    switch (type) {
      case FormQuestionType.text:
      case FormQuestionType.numeric:
        String? initialValue = (answerValue != null && answerValue.isNotEmpty)
            ? answerValue[0]
            : null;
        final answerController = TextEditingController(text: initialValue);

        questionWidgets.add(
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: answerController,
                    focusNode: _focusNode,
                    keyboardType: type == FormQuestionType.numeric
                        ? TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.text,
                    inputFormatters: type == FormQuestionType.numeric
                        ? [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9,\.]'))
                          ]
                        : null,
                    onSaved: (value) {
                      if (!widget.userCanEditForm) return;
                      if (value == null || value.isEmpty) {
                        _handleChangeOfFormAnswer(
                          question: widget.formQuestion.title,
                          questionId: questionId,
                          newValue: null,
                          ref: ref,
                          context: context,
                        );
                        return;
                      }

                      if (type == FormQuestionType.numeric) {
                        final normalized = value.replaceAll(',', '.');
                        final parsed = double.tryParse(normalized);
                        if (parsed == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Ongeldig nummer")));
                          return;
                        }
                        _handleChangeOfFormAnswer(
                          question: widget.formQuestion.title,
                          questionId: questionId,
                          newValue: [parsed.toString()],
                          ref: ref,
                          context: context,
                        );
                      } else {
                        _handleChangeOfFormAnswer(
                          question: widget.formQuestion.title,
                          questionId: questionId,
                          newValue: [value],
                          ref: ref,
                          context: context,
                        );
                      }
                    },
                    enabled: widget.userCanEditForm && !answerIsDefinitive,
                  ),
                ),
                if (widget.showAdditionalSaveButton &&
                    widget.userCanEditForm &&
                    !answerIsDefinitive)
                  TextButton(
                    onPressed: () => _formKey.currentState?.save(),
                    child: const Text("Opslaan"),
                  ),
              ],
            ),
          ),
        );
        break;

      case FormQuestionType.singleChoice:
        questionWidgets.add(SingleChoiceWidget(
          session: widget.session,
          questionId: widget.questionId!,
          onChanged: (value) => _handleChangeOfFormAnswer(
            question: widget.formQuestion.title,
            questionId: questionId,
            newValue: value != null ? [value] : null,
            ref: ref,
            context: context,
          ),
          userCanEditForm: widget.userCanEditForm && !answerIsDefinitive,
        ));
        break;

      case FormQuestionType.multipleChoice:
        final values = answerValue ?? <String>[];
        questionWidgets.add(MultipleChoiceWidget(
          session: widget.session,
          questionId: widget.questionId!,
          onChanged: (newValues) => _handleChangeOfFormAnswer(
            question: widget.formQuestion.title,
            questionId: questionId,
            newValue: newValues,
            ref: ref,
            context: context,
          ),
          userCanEditForm: widget.userCanEditForm && !answerIsDefinitive,
        ));
        break;

      case FormQuestionType.date:
        DateTime? answerDate;
        if (answerValue != null && answerValue.isNotEmpty) {
          try {
            answerDate = DateTime.parse(answerValue[0]).toLocal();
          } catch (_) {
            answerDate = null;
          }
        }

        questionWidgets.add(DateChoiceWidget(
          session: widget.session,
          questionId: widget.questionId!,
          userCanEditForm: widget.userCanEditForm && !answerIsDefinitive,
          onChanged: (value) => _handleChangeOfFormAnswer(
            question: widget.formQuestion.title,
            questionId: questionId,
            newValue: value != null ? [value] : null,
            ref: ref,
            context: context,
          ),
        ));
        break;

      case FormQuestionType.image:
        questionWidgets.add(FormImageWidget(
          session: widget.session,
          questionId: widget.formQuestion.id!,
          userCanEditForm: widget.userCanEditForm && !answerIsDefinitive,
          onChanged: (value) => _handleChangeOfFormAnswer(
            question: widget.formQuestion.title,
            questionId: questionId,
            newValue: value != null ? [value] : null,
            ref: ref,
            context: context,
          ),
        ));
        break;

      case FormQuestionType.unsupported:
      default:
        questionWidgets.add(Card(
          color: colorScheme.errorContainer,
          elevation: 0,
          margin: EdgeInsets.zero,
          child: const Text(
            "Jouw versie ondersteunt dit vraagtype niet. Update de app.",
          ).padding(
            horizontal: horizontalPaddingCard,
            vertical: verticalPaddingCard,
          ),
        ));
    }

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
