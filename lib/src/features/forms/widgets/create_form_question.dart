import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:styled_widget/styled_widget.dart';

class CreateFormQuestion extends ConsumerWidget {
  const CreateFormQuestion({
    super.key,
    required this.index,
    required this.question,
    required this.onChanged,
    required this.deleteQuestion,
  });

  final int index;
  final FirestoreFormQuestion question;
  final VoidCallback onChanged;
  // ignore: prefer-correct-callback-field-name, prefer-explicit-parameter-names
  final Function(int) deleteQuestion;

  Widget _buildQuestionExtras(
    FirestoreFormQuestion q,
    VoidCallback onChange,
    // ignore: avoid-long-functions
  ) {
    switch (q.type) {
      case FormQuestionType.singleChoice:
        return [
          ...(q.options ?? []).asMap().entries.map((optionEntry) {
            int optionIndex = optionEntry.key;
            TextEditingController option =
                TextEditingController(text: optionEntry.value);

            return [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 32),
                  Expanded(
                    child: TextFormField(
                      controller: option,
                      decoration: InputDecoration(
                        labelText: 'Optie ${optionIndex + 1}',
                      ),
                      onChanged: (String value) =>
                          // ignore: avoid-collection-mutating-methods, avoid-non-null-assertion
                          {q.options![optionIndex] = value},
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Optie kan niet leeg zijn.'
                          : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () => {
                        // ignore: avoid-non-null-assertion, avoid-collection-mutating-methods
                        q.options!.removeAt(optionIndex),
                        onChange(),
                      },
                      icon: Icon(Icons.delete, color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ].toColumn();
          }),
          if (q.type == FormQuestionType.singleChoice)
            const SizedBox(height: 16),
          ElevatedButton(
            // ignore: avoid-non-null-assertion, avoid-collection-mutating-methods
            onPressed: () => {q.options!.add(''), onChange()},
            child: const Text('Voeg een optie toe'),
          ),
        ].toColumn();

      case FormQuestionType.text:
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController? questionController =
        TextEditingController(text: question.title);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Column(children: [
        [
          DropdownButton<FormQuestionType>(
            items: FormQuestionType.values
                .where((type) => type != FormQuestionType.unsupported)
                .map<DropdownMenuItem<FormQuestionType>>(
              (FormQuestionType value) {
                return DropdownMenuItem<FormQuestionType>(
                  value: value,
                  child: Text(value.name.toString()),
                );
              },
            ).toList(),
            value: question.type,
            // ignore: prefer-extracting-callbacks
            onChanged: (FormQuestionType? newValue) {
              question.type = newValue ?? question.type;
              onChanged();
            },
          ),
          [
            const Text(
              'Verplicht',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Switch.adaptive(
              value: question.isRequired,
              onChanged: (bool value) =>
                  {question.isRequired = value, onChanged()},
            ),
          ].toRow(),
        ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        TextFormField(
          controller: questionController,
          decoration: InputDecoration(labelText: 'Vraag ${index + 1}'),
          onChanged: (String value) => {question.title = value},
          validator: (value) => (value == null || value.isEmpty)
              ? 'Geef een naam op voor de vraag.'
              : null,
        ),
        // ignore: avoid-returning-widgets
        _buildQuestionExtras(question, onChanged),
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
