import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:styled_widget/styled_widget.dart';

class CreateFormQuestion extends ConsumerWidget {
  const CreateFormQuestion({
    Key? key,
    required this.index,
    required this.question,
    required this.onChanged,
    required this.deleteQusetion,
  }) : super(key: key);

  final int index;
  final FirestoreFormQuestion question;
  final VoidCallback onChanged;
  final Function(int) deleteQusetion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController? questionController = TextEditingController(text: question.label);

    return Column(
      children: [
        TextFormField(
          controller: questionController,
          decoration: InputDecoration(
            labelText: 'Vraag ${index + 1}',
          ),
          onChanged: (String value) => {question.label = value},
        ),
        DropdownButton<FormQuestionType>(
          items:
              FormQuestionType.values.map<DropdownMenuItem<FormQuestionType>>(
            (FormQuestionType value) {
              return DropdownMenuItem<FormQuestionType>(
                value: value,
                child: Text(value.name.toString()),
              );
            },
          ).toList(),
          value: question.type,
          onChanged: (FormQuestionType? newValue) =>
              {question.type = newValue!, onChanged()},
        ),
        if (question.type == FormQuestionType.singleChoice)
          ...(question.options ?? []).asMap().entries.map((optionEntry) {
            int optionIndex = optionEntry.key;
            String option = optionEntry.value;

            return [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Optie ${optionIndex + 1}',
                ),
                onChanged: (String value) => {option = value, onChanged()},
              ),
              ElevatedButton(
                onPressed: () => {
                  question.options!.removeAt(optionIndex),
                  onChanged(),
                },
                child: const Text("Verwijder optie"),
              ),
            ].toColumn();
          }).toList(),
        if (question.type == FormQuestionType.singleChoice)
          ElevatedButton(
            onPressed: () => {question.options!.add(''), onChanged()},
            child: const Icon(Icons.add),
          ),
        ElevatedButton(
          onPressed: () => deleteQusetion(index),
          child: const Text("Verwijder vraag"),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}