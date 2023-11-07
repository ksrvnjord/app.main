// ignore_for_file: prefer-extracting-callbacks, avoid-passing-async-when-sync-expected

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events_provider.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:styled_widget/styled_widget.dart';

class ManageEventsPage extends ConsumerWidget {
  const ManageEventsPage({Key? key}) : super(key: key);

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

  Widget _buildCreateEventBottomSheet() {
    final titleController = TextEditingController();
    final startDateController = TextEditingController();
    final startTimeController = TextEditingController();
    final endDateController = TextEditingController();
    final endTimeController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Maak nieuw evenement',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start datum',
                  border: OutlineInputBorder(),
                ),
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
              ),
              const SizedBox(height: 16),
              TextField(
                controller: startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Start tijd',
                  border: OutlineInputBorder(),
                ),
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
              ),
              const SizedBox(height: 16),
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(
                  labelText: 'Eind datum',
                  border: OutlineInputBorder(),
                ),
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
              ),
              const SizedBox(height: 16),
              TextField(
                controller: endTimeController,
                decoration: const InputDecoration(
                  labelText: 'Eind tijd',
                  border: OutlineInputBorder(),
                ),
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
              ),
              ElevatedButton(
                // ignore: prefer-extracting-callbacks
                onPressed: () {
                  final title = titleController.text.trim();

                  final startDateTime = mergeDateAndTimeStrings(
                    startDateController.text,
                    startTimeController.text,
                  );

                  final endDateTime = mergeDateAndTimeStrings(
                    endDateController.text,
                    endTimeController.text,
                  );

                  if (title.isNotEmpty) {
                    Navigator.of(context).pop(Event(
                      title: title,
                      startTime: Timestamp.fromDate(startDateTime),
                      endTime: Timestamp.fromDate(endDateTime),
                    ));
                  }
                },
                child: const Text('Maak Evenement'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comingEventsVal = ref.watch(comingEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beheer Evenementen'),
      ),
      body: comingEventsVal.when(
        data: (snapshot) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final eventDoc = snapshot.docs[index];
              final Event event = eventDoc.data();

              return ListTile(
                title: Text(event.title),
                subtitle: Text(
                  'van ${event.startTime.toDate()} tot ${event.endTime.toDate()}',
                ),
                trailing: IconButton(
                  onPressed: () async {
                    await eventDoc.reference.delete();
                    if (!context.mounted) return;
                    // ignore: avoid-ignoring-return-values
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Evenement verwijderd'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
            itemCount: snapshot.size,
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        // ignore: avoid-passing-async-when-sync-expected, prefer-extracting-callbacks
        onPressed: () async {
          final Event? result = await showModalBottomSheet(
            context: context,
            builder: (context) => _buildCreateEventBottomSheet()
                .padding(bottom: MediaQuery.of(context).viewInsets.bottom),
            isScrollControlled: true,
          );
          if (result != null && context.mounted) {
            try {
              final res = await Event.firestoreConverter.add(result);

              if (!context.mounted) return;
              // ignore: avoid-ignoring-return-values
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Evenement aangemaakt ${res.path}'),
                ),
              );
            } catch (e) {
              // ignore: avoid-ignoring-return-values
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Er is iets misgegaan: $e'),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
