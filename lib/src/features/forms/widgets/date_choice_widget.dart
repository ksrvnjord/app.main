import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';

class DateChoiceWidget extends StatelessWidget {
  const DateChoiceWidget({
    super.key,
    required this.answerValueDateTime,
    required this.question,
    required this.userCanEditForm,
    required this.onChanged,
  });

  final DateTime? answerValueDateTime;
  final FirestoreFormQuestion question;
  final bool userCanEditForm;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final startDate = question.startDate!;
    final endDate = question.endDate!;
    final initialDate =
        DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate)
            ? DateTime.now()
            : (DateTime.now().isBefore(startDate) ? startDate : endDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0), // Optional padding for better styling
      child: GestureDetector(
        onTap: userCanEditForm
            ? () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: answerValueDateTime ?? initialDate,
                  firstDate: startDate,
                  lastDate: endDate,
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
                answerValueDateTime != null
                    ? answerValueDateTime.toString().split(' ')[0]
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
