// ignore_for_file: prefer-extracting-callbacks, avoid-passing-async-when-sync-expected

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/events/create_event_bottom_sheet.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events_provider.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:styled_widget/styled_widget.dart';

class ManageEventsPage extends ConsumerWidget {
  const ManageEventsPage({Key? key}) : super(key: key);

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
            builder: (context) => const CreateEventBottomSheet(),
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
