import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/upsert_form_answer.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class MultipleChoiceWidget extends StatelessWidget {
  final String? value; // Given answer
  final FirestoreFormQuestion formQuestion;
  final DocumentSnapshot<FirestoreForm> formDoc;
  final WidgetRef ref;

  const MultipleChoiceWidget({
    this.value,
    required this.formQuestion,
    required this.formDoc,
    required this.ref,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = formQuestion.options;

    return options == null
        ? const ErrorCardWidget(
            errorMessage: 'Er zijn geen opties voor deze vraag',
          )
        : Column(
            children: options
                .map((choice) => RadioListTile<String>(
                      value: choice,
                      groupValue: null,
                      onChanged: (String? choice) => upsertFormAnswer(
                        value: choice,
                        question: formQuestion.label,
                        formDoc: formDoc,
                        ref: ref,
                      ),
                      toggleable: true,
                      title: Text(choice),
                    ))
                .toList(),
          );
  }
}
