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
    required this.deleteQuestion,
  }) : super(key: key);

  final int index;
  final FirestoreFormQuestion question;
  final VoidCallback onChanged;
  final Function(int) deleteQuestion;

  Widget _buildQuestionExtras(
    BuildContext context,
    WidgetRef ref,
    FirestoreFormQuestion question,
    VoidCallback onChanged,
  ) {
    switch (question.type) {
      case FormQuestionType.singleChoice:
        return [
          ...(question.options ?? []).asMap().entries.map((optionEntry) {
            int optionIndex = optionEntry.key;
            TextEditingController option =
                TextEditingController(text: optionEntry.value);

            return [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: option,
                      decoration: InputDecoration(
                        labelText: 'Optie ${optionIndex + 1}',
                      ),
                      onChanged: (String value) =>
                          {question.options![optionIndex] = value},
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () => {
                        question.options!.removeAt(optionIndex),
                        onChanged(),
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ].toColumn();
          }).toList(),
          if (question.type == FormQuestionType.singleChoice)
            const SizedBox(
              height: 16,
            ),
          ElevatedButton(
            onPressed: () => {question.options!.add(''), onChanged()},
            child: const Text('Voeg een optie toe'),
          ),
        ].toColumn();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController? questionController =
        TextEditingController(text: question.label);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Column(children: [
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
        TextFormField(
          controller: questionController,
          decoration: InputDecoration(labelText: 'Vraag ${index + 1}'),
          onChanged: (String value) => {question.label = value},
        ),
        _buildQuestionExtras(context, ref, question, onChanged),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () => deleteQuestion(index),
              child: const Text("Verwijder vraag"),
            ),
          ),
        ),
      ]),
    );
  }
}
