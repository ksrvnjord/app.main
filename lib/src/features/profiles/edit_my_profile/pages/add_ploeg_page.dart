import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry_create_notifier.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AddPloegPage extends ConsumerWidget {
  const AddPloegPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ploegEntryForm = ref.watch(ploegEntryCreateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voeg ploeg toe'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: [
        const Text("Je bent een").fontSize(20),
        SegmentedButton<PloegRole>(
          segments: [
            for (final ploegType in PloegRole.values)
              ButtonSegment(
                label: Text(ploegType.value),
                value: ploegType,
              ),
          ],
          selected: {
            ploegEntryForm.role,
          },
          onSelectionChanged: (types) => ref
              .read(ploegEntryCreateNotifierProvider.notifier)
              .setRole(types.first),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        // ignore: prefer-extracting-callbacks
        onPressed: () {
          ref
              .read(ploegEntryCreateNotifierProvider.notifier)
              .createPloegEntry();
          // show confirmation dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ploeg succesvol toegevoegd'),
              backgroundColor: Colors.green,
            ),
          );
          Routemaster.of(context).replace('/home/edit/groups');
        },
        label: const Text('Opslaan'),
        icon: const Icon(Icons.save),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
