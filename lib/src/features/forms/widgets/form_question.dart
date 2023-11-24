import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/upsert_form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/multiple_choice_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class FormQuestion extends ConsumerWidget {
  const FormQuestion({
    Key? key,
    required this.questionMap,
    required this.formPath,
    required this.formDoc,
  }) : super(key: key);

  final FirestoreFormQuestion questionMap;

  final String formPath;

  final DocumentSnapshot<FirestoreForm> formDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final type = questionMap.type;

    final List<Widget> questionWidgets = [
      Text(
        questionMap.label,
        style: textTheme.titleLarge,
      ),
    ];

    switch (type) {
      case 'TEXT':
        questionWidgets.add(
          TextFormField(
            onFieldSubmitted: (String value) => {
              upsertFormAnswer(
                value: value,
                question: questionMap.label,
                formDoc: formDoc,
                ref: ref,
              ),
            },
          ),
        );
        break;
      case 'Multiplechoice':
        questionWidgets.add(MultipleChoiceWidget(
          value: null,
          formQuestion: questionMap,
          formDoc: formDoc,
          ref: ref,
        ));
        break;
      default:
        return const ErrorCardWidget(
          errorMessage: 'Onbekend type vraag',
        );
    }

    return questionWidgets.toColumn();
  }
}
