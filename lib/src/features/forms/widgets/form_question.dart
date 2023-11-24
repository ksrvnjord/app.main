import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    required this.formPath,
    required this.form,
    required this.docRef,
  }) : super(key: key);

  final FirestoreFormQuestion formQuestion;

  final String formPath;

  final FirestoreForm form;

  final DocumentReference<FirestoreForm> docRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final type = formQuestion.type;

    final List<Widget> questionWidgets = [
      Text(
        formQuestion.label,
        style: textTheme.titleLarge,
      ),
    ];

    switch (type) {
      case FormQuestionType.text:
        questionWidgets.add(
          TextFormField(
            onFieldSubmitted: (String value) => {
              FormRepository.upsertFormAnswer(
                newValue: value,
                question: formQuestion.label,
                form: form,
                docRef: docRef,
                ref: ref,
              ),
            },
          ),
        );
        break;
      case FormQuestionType.singleChoice:
        questionWidgets.add(SingleChoiceWidget(
          initialValue: null,
          formQuestion: formQuestion,
          form: form,
          docRef: docRef,
          ref: ref,
          onChanged: (String? value) => FormRepository.upsertFormAnswer(
            newValue: value,
            question: formQuestion.label,
            docRef: docRef,
            form: form,
            ref: ref,
          ),
        ));
        break;
      default:
        return const ErrorCardWidget(
          errorMessage: 'Onbekend type vraag',
        );
    }

    return questionWidgets.toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
