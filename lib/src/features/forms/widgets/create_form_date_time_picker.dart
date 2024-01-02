import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateFormDateTimePicker extends StatefulWidget {
  const CreateFormDateTimePicker({
    Key? key,
    required this.initialDate,
    required this.onDateTimeChanged,
  }) : super(key: key);

  final DateTime initialDate;
  // ignore: prefer-explicit-parameter-names
  final Function(DateTime) onDateTimeChanged;

  @override
  createState() => _CreateFormDateTimePickerState();
}

class _CreateFormDateTimePickerState extends State<CreateFormDateTimePicker> {
  // ignore: avoid-late-keyword
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(
        text: DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate),
      ),
      decoration: const InputDecoration(labelText: 'Open tot:'),
      readOnly: true,
      // ignore: prefer-extracting-callbacks, avoid-passing-async-when-sync-expected
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null && context.mounted) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_selectedDate),
            builder: (BuildContext innerContext, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(innerContext)
                    .copyWith(alwaysUse24HourFormat: true),
                // ignore: avoid-non-null-assertion
                child: child!,
              );
            },
          );

          if (pickedTime != null) {
            DateTime dateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            if (!mounted) return;
            setState(() {
              _selectedDate = dateTime;
            });

            // ignore: avoid-ignoring-return-values
            widget.onDateTimeChanged(dateTime);
          }
        }
      },
    );
  }
}
