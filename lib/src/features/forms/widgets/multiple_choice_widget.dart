import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';

class MultipleChoiceWidget extends StatefulWidget {
  const MultipleChoiceWidget({
    required this.formQuestion,
    required this.onChanged,
    required this.formIsOpen,
    required this.initialValues,
    super.key,
  });

  final List<String> initialValues;
  final FirestoreFormQuestion formQuestion;
  final void Function(List<String>) onChanged;
  final bool formIsOpen;

  @override
  State<MultipleChoiceWidget> createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  late Set<String> selectedChoices;

  @override
  void initState() {
    super.initState();
    selectedChoices = widget.initialValues.toSet();
  }

  void _toggleSelection(String choice) {
    setState(() {
      if (selectedChoices.contains(choice)) {
        selectedChoices.remove(choice);
      } else {
        selectedChoices.add(choice);
      }
    });

    widget.onChanged(selectedChoices.toList());
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.formQuestion.options;

    if (options == null) {
      return const Text('Er zijn geen opties voor deze vraag');
    }

    return Column(
      children: options.map((choice) {
        return CheckboxListTile(
          title: Text(choice),
          value: selectedChoices.contains(choice),
          onChanged: widget.formIsOpen ? (_) => _toggleSelection(choice) : null,
        );
      }).toList(),
    );
  }
}
