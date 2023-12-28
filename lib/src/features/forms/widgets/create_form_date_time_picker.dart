import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateFormDateTimePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateTimeChanged;

  const CreateFormDateTimePicker({
    Key? key,
    required this.initialDate,
    required this.onDateTimeChanged,
  }) : super(key: key);

  @override
  _CreateFormDateTimePickerState createState() =>
      _CreateFormDateTimePickerState();
}

class _CreateFormDateTimePickerState extends State<CreateFormDateTimePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(
        text: DateFormat('yyyy-MM-dd HH:mm').format(selectedDate),
      ),
      decoration: const InputDecoration(labelText: 'Open tot:'),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(selectedDate),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
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

            setState(() {
              selectedDate = dateTime;
            });

            widget.onDateTimeChanged(dateTime);
          }
        }
      },
    );
  }
}
