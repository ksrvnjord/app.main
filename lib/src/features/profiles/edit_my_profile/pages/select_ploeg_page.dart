import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry_create_notifier.dart';
import 'package:styled_widget/styled_widget.dart';

class SelectPloegPage extends ConsumerWidget {
  const SelectPloegPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ploegEntryForm = ref.watch(ploegEntryCreateNotifierProvider);
    final ploegen = ref.watch(ploegenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies een ploeg'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: [
        SegmentedButton<PloegType>(
          segments: [
            for (final ploegType in PloegType.values)
              ButtonSegment(
                label: Text(ploegType.name),
                value: ploegType,
              ),
          ],
          selected: {
            ploegEntryForm.ploegType,
          },
          onSelectionChanged: (types) => ref
              .read(ploegEntryCreateNotifierProvider.notifier)
              .setPloegType(types.first),
        ),
        const SizedBox(height: 16),
        const Text("Ploegen").fontSize(24),
        for (final ploeg in ploegen)
          ListTile(
            title: Text(ploeg),
          ),
      ]),
    );
  }
}
