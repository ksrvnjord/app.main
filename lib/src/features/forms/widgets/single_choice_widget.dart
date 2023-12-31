import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

/// A widget for displaying a single choice question.
///
/// This widget takes a [FirestoreFormQuestion] and displays it as a list of radio buttons.
/// The user can select one option from the list.
///
/// The [initialValue] is the initial value of the question.
/// The [formQuestion] is the question to be displayed.
/// The [form] is the form that contains the question.
/// The [docRef] is the document reference of the form.
/// The [ref] is the widget reference.
/// The [onChanged] function is called when the user selects an option.
///
/// If the [formQuestion] does not have any options, an error message is displayed.

class SingleChoiceWidget extends StatelessWidget {
  const SingleChoiceWidget({
    this.initialValue,
    required this.formQuestion,
    required this.onChanged,
    required this.formIsOpen,
    Key? key,
  }) : super(key: key);

  final String? initialValue;
  final FirestoreFormQuestion formQuestion;
  // ignore: prefer-explicit-parameter-names
  final void Function(String?) onChanged;
  final bool formIsOpen;

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
                      groupValue: initialValue,
                      onChanged: formIsOpen ? onChanged : null,
                      title: Text(choice),
                    ))
                .toList(),
          );
  }
}
