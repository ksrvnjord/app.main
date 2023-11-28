import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

/// A widget for displaying a single choice question.
///
/// This widget takes a [FirestoreFormQuestion] and displays it as a list of radio buttons.
/// The user can select one option from the list.
///
/// The [initialValue] is the answer that was previously given for this question, if any.
/// The [formQuestion] is the question to be displayed.
/// The [form] is the form that contains the question.
/// The [docRef] is the document reference of the form.
/// The [ref] is the widget reference.
/// The [onChanged] function is called when the user selects an option.
///
/// If the [formQuestion] does not have any options, an error message is displayed.
class SingleChoiceWidget extends StatelessWidget {
  final String? initialValue; // Given answer.
  final FirestoreFormQuestion formQuestion;
  final FirestoreForm form;
  final DocumentReference<FirestoreForm> docRef;
  final WidgetRef ref;
  final void Function(String?) onChanged;

  const SingleChoiceWidget({
    this.initialValue,
    required this.formQuestion,
    required this.form,
    required this.docRef,
    required this.ref,
    required this.onChanged,
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
                      onChanged: onChanged,
                      toggleable: true,
                      title: Text(choice),
                    ))
                .toList(),
          );
  }
}
