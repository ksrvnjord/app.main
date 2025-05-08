import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';

class DateChoiceWidget extends StatelessWidget {
  const DateChoiceWidget({
    super.key,
    required this.initialValue,
    required this.question,
    required this.formIsOpen,
    required this.onChanged,
  });

  final DateTime? initialValue;
  final FirestoreFormQuestion question;
  final bool formIsOpen;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final minDate = DateTime(1874);
    final maxDate = DateTime(getNjordYear() + 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0), // Optional padding for better styling
      child: GestureDetector(
        onTap: formIsOpen
            ? () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: initialValue ?? DateTime.now(),
                  firstDate: question.startDate ?? minDate,
                  lastDate: question.endDate ?? maxDate,
                );
                if (selectedDate != null) {
                  onChanged(selectedDate.toIso8601String());
                }
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8.0),
              Text(
                initialValue != null
                    ? initialValue.toString().split(' ')[0]
                    : 'Selecteer een datum',
                style: textTheme.bodyLarge?.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
