import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/forms/widgets/create_form_move_arrows.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:styled_widget/styled_widget.dart';

class CreateFormQuestion extends ConsumerWidget {
  const CreateFormQuestion({
    super.key,
    required this.index,
    required this.question,
    required this.questionId,
    required this.onChanged,
    required this.deleteQuestion,
  });

  // The position of the question in the form
  final int index;
  final FirestoreFormQuestion question;
  // The question id of the question to match answers to
  final int questionId;
  final VoidCallback onChanged;
  // ignore: prefer-correct-callback-field-name, prefer-explicit-parameter-names
  final Function() deleteQuestion;

  Widget _datePicker({
    required BuildContext context,
    required FirestoreFormQuestion question,
    required DateTime? pickedDate,
    required bool isStartDate,
    // required DateTime? selectedDate,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    final minDate = DateTime(1874);
    final maxDate = DateTime(getNjordYear() + 100);

    if (pickedDate == null) {
      isStartDate ? question.startDate = minDate : question.endDate = maxDate;
      pickedDate = isStartDate ? minDate : maxDate;
    }

    final initialDateString = pickedDate.toString().split(' ')[0];

    return Column(
      children: [
        Text(
          '${isStartDate ? 'minimale' : 'maximale'} datum:',
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: minDate,
              lastDate: maxDate,
            );
            if (selectedDate != null) {
              if (isStartDate) {
                question.startDate = selectedDate;
              } else {
                question.endDate = selectedDate;
              }
              onChanged();
            }
          },
          child: Text(
            initialDateString,
            style: textTheme.bodyLarge?.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionExtras(
    FirestoreFormQuestion q,
    VoidCallback onChange,
    BuildContext context,
    // ignore: avoid-long-functions
  ) {
    switch (q.type) {
      case FormQuestionType.singleChoice || FormQuestionType.multipleChoice:
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Optie kan niet leeg zijn.';
                        }
                        if (q.options != null &&
                            q.options!.where((opt) => opt == value).length >
                                1) {
                          return 'Opties moeten uniek zijn.';
                        }
                        return null;
                      },
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
          if (q.type == FormQuestionType.singleChoice ||
              q.type == FormQuestionType.multipleChoice)
            const SizedBox(height: 16),
          ElevatedButton(
            // ignore: avoid-non-null-assertion, avoid-collection-mutating-methods
            onPressed: () => {q.options!.add(''), onChange()},
            child: const Text('Voeg een optie toe'),
          ),
        ].toColumn();

      case FormQuestionType.date:
        // Condition check
        if (q.startDate != null && q.endDate != null) {
          q.startDate =
              q.startDate!.isBefore(q.endDate!) ? q.startDate : q.endDate;
          q.endDate =
              q.endDate!.isAfter(q.startDate!) ? q.endDate : q.startDate;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _datePicker(
              context: context,
              question: q,
              pickedDate: q.startDate,
              isStartDate: true,
              colorScheme: Theme.of(context).colorScheme,
              textTheme: Theme.of(context).textTheme,
            ),
            const SizedBox(width: 16),
            _datePicker(
              context: context,
              question: q,
              pickedDate: q.endDate,
              isStartDate: false,
              colorScheme: Theme.of(context).colorScheme,
              textTheme: Theme.of(context).textTheme,
            ),
          ],
        ).padding(top: 8.0);

      case FormQuestionType.text:
      case FormQuestionType.image:
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController? questionController =
        TextEditingController(text: question.title);

    return Row(
      children: [
        Expanded(
          // or Flexible
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                [
                  DropdownButton<FormQuestionType>(
                    items: FormQuestionType.values
                        .where((type) => type != FormQuestionType.unsupported)
                        .map<DropdownMenuItem<FormQuestionType>>(
                      (FormQuestionType value) {
                        return DropdownMenuItem<FormQuestionType>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(value.icon, size: 20),
                              const SizedBox(width: 8),
                              Text(value.label),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                    value: question.type,
                    onChanged: (FormQuestionType? newValue) {
                      question.type = newValue ?? question.type;
                      onChanged();
                    },
                  ),
                  [
                    const Text(
                      'Verplicht',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Checkbox.adaptive(
                      value: question.isRequired,
                      onChanged: (bool? value) {
                        question.isRequired = value ?? false;
                        onChanged();
                      },
                    )
                  ].toRow(),
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                TextFormField(
                  controller: questionController,
                  decoration: InputDecoration(labelText: 'Vraag ${index + 1}'),
                  onChanged: (String value) => question.title = value,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Geef een naam op voor de vraag.'
                      : null,
                ),
                _buildQuestionExtras(question, onChanged, context),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () => deleteQuestion(),
                      child: const Text("Verwijder vraag"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CreateFormMoveArrows(
            index: index, contentIndex: questionId), // This is fine now
      ],
    );
  }
}
