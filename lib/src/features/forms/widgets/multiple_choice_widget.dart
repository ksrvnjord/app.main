import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';

class MultipleChoiceWidget extends StatelessWidget {
  const MultipleChoiceWidget({
    required this.formQuestion,
    required this.onChanged,
    required this.userCanEditForm,
    required this.initialValues,
    super.key,
  });

  final List<String> initialValues;
  final FirestoreFormQuestion formQuestion;
  final void Function(List<String>) onChanged;
  final bool userCanEditForm;

  void _toggleSelection(String choice, Set<String> selectedChoices) {
    if (selectedChoices.contains(choice)) {
      selectedChoices.remove(choice);
    } else {
      selectedChoices.add(choice);
    }
    onChanged(selectedChoices.toList());
  }

  @override
  Widget build(BuildContext context) {
    final options = formQuestion.options;
    Set<String> selectedChoices = initialValues.toSet();

    if (options == null) {
      return const Text('Er zijn geen opties voor deze vraag');
    }

    return Column(
      children: options.map((choice) {
        return CheckboxListTile(
          title: Text(choice),
          value: selectedChoices.contains(choice),
          onChanged: userCanEditForm
              ? (_) => _toggleSelection(choice, selectedChoices)
              : null,
        );
      }).toList(),
    );
  }
}
