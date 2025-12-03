import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/form_repository.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'create_form_date_time_picker.dart';

class EditFormDateTimeWidget extends StatefulWidget {
  const EditFormDateTimeWidget({
    super.key,
    required this.name,
    required this.initialDate,
    required this.docRef,
  });

  final String name;
  final DateTime initialDate;
  final DocumentReference<FirestoreForm> docRef;

  @override
  State<EditFormDateTimeWidget> createState() => _EditFormDateTimeWidgetState();
}

class _EditFormDateTimeWidgetState extends State<EditFormDateTimeWidget> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
  }

  Future<void> _openDateTimeDialog(BuildContext context) async {
    DateTime tempDate = _currentDate; // temporary date inside the dialog

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.name),
          content: CreateFormDateTimePicker(
            initialDate: tempDate,
            onDateTimeChanged: (newDateTime) {
              tempDate = newDateTime; // only update temp
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // cancel
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // 🔹 Call Firestore update
                  await FormRepository.updateOpenUntilTime(
                    widget.docRef,
                    tempDate,
                  );

                  // 🔹 Commit the change to the main UI
                  if (mounted) setState(() => _currentDate = tempDate);

                  // 🔹 Close dialog
                  if (context.mounted) Navigator.pop(context);

                  // 🔹 Show success snackbar
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("'Open tot' tijd succesvol bijgewerkt."),
                        backgroundColor: Colors.green.shade400,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Fout bij bijwerken: $e, update onsuccesvol.'),
                        backgroundColor: Colors.red.shade400,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: const Text('Opslaan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      title: Text(
        widget.name,
        style: textTheme.labelLarge,
      ),
      subtitle: Text(
        '${MaterialLocalizations.of(context).formatFullDate(_currentDate)} ${TimeOfDay.fromDateTime(_currentDate).format(context)}',
        style: textTheme.titleLarge,
      ),
      trailing: const Icon(Icons.edit, size: 20),
      onTap: () => _openDateTimeDialog(context),
    );
  }
}
