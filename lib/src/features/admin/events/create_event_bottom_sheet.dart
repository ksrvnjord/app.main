import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:styled_widget/styled_widget.dart';

class CreateEventBottomSheet extends StatefulWidget {
  const CreateEventBottomSheet({Key? key}) : super(key: key);

  @override
  createState() => _CreateEventBottomSheetState();
}

class _CreateEventBottomSheetState extends State<CreateEventBottomSheet> {
  final titleController = TextEditingController();
  final startDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endDateController = TextEditingController();
  final endTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime mergeDateAndTimeStrings(String date, String time) {
    final parsedDate = DateTime.parse(date);
    final parsedTime =
        TimeOfDay.fromDateTime(DateTime.parse('1970-01-01 $time'));

    return DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    const double formPadding = 16;
    const double bottomPaddingModal = 16;

    return Form(
      key: _formKey,
      child: [
        Text(
          'Maak nieuw evenement',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Titel',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Titel mag niet leeg zijn'
              : null,
        ),
        TextFormField(
          controller: startDateController,
          decoration: const InputDecoration(
            labelText: 'Start datum',
            border: OutlineInputBorder(),
          ),
          // ignore: avoid-passing-async-when-sync-expected, prefer-extracting-callbacks
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              // ignore: no-equal-arguments
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 5),
            );
            if (date != null) {
              startDateController.text = date.toIso8601String();
            }
          },
          validator: (value) => value == null || value.isEmpty
              ? 'Start datum mag niet leeg zijn'
              : null,
        ),
        TextFormField(
          controller: startTimeController,
          decoration: const InputDecoration(
            labelText: 'Start tijd',
            border: OutlineInputBorder(),
          ),
          // ignore: avoid-passing-async-when-sync-expected, prefer-extracting-callbacks
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null && context.mounted) {
              startTimeController.text = time.format(context);
            }
          },
          validator: (value) => value == null || value.isEmpty
              ? 'Start tijd mag niet leeg zijn'
              : null,
        ),
        TextFormField(
          controller: endDateController,
          decoration: const InputDecoration(
            labelText: 'Eind datum',
            border: OutlineInputBorder(),
          ),
          // ignore: avoid-passing-async-when-sync-expected, prefer-extracting-callbacks
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              // ignore: no-equal-arguments
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 5),
            );
            if (date != null) {
              endDateController.text = date.toIso8601String();
            }
          },
          validator: (value) => value == null || value.isEmpty
              ? 'Eind datum mag niet leeg zijn'
              : null,
        ),
        TextFormField(
          controller: endTimeController,
          decoration: const InputDecoration(
            labelText: 'Eind tijd',
            border: OutlineInputBorder(),
          ),
          // ignore: avoid-passing-async-when-sync-expected, prefer-extracting-callbacks
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null && context.mounted) {
              endTimeController.text = time.format(context);
            }
          },
          validator: (value) => value == null || value.isEmpty
              ? 'Eind tijd mag niet leeg zijn'
              : null,
        ),
        FilledButton(
          // ignore: prefer-extracting-callbacks
          onPressed: () {
            final currentState = _formKey.currentState;
            if (currentState != null && currentState.validate()) {
              currentState.save();
              // Only navigate if all fields are valid.
              final title = titleController.text.trim();

              final startDateTime = mergeDateAndTimeStrings(
                startDateController.text,
                startTimeController.text,
              );

              final endDateTime = mergeDateAndTimeStrings(
                endDateController.text,
                endTimeController.text,
              );

              Navigator.of(context).pop(Event(
                title: title,
                startTime: Timestamp.fromDate(startDateTime),
                endTime: Timestamp.fromDate(endDateTime),
              ));
            }
          },
          child: const Text('Maak Evenement'),
        ),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        separator: const SizedBox(height: 16),
      ),
    ).padding(
      all: formPadding,
      bottom: MediaQuery.of(context).viewInsets.bottom + bottomPaddingModal,
    );
  }
}
