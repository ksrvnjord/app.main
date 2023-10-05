import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry_create_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/years_from_1874.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:styled_widget/styled_widget.dart';

class AddPloegPage extends ConsumerWidget {
  const AddPloegPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ploegEntryForm = ref.watch(ploegEntryCreateNotifierProvider);

    final years = yearsFrom1874;

    const double dropdownMenuMaxHeight = 200;
    const double labelFontSize = 20;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voeg ploeg toe'),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: [
        DataTextListTile(name: "Ploeg", value: ploegEntryForm.name ?? ""),
        const SizedBox(height: 32),
        const Text("Ik ben een").fontSize(labelFontSize),
        const SizedBox(height: 8),
        SegmentedButton<PloegRole>(
          segments: [
            for (final ploegType in PloegRole.values)
              ButtonSegment(value: ploegType, label: Text(ploegType.value)),
          ],
          selected: {
            ploegEntryForm.role,
          },
          onSelectionChanged: (types) => ref
              .read(ploegEntryCreateNotifierProvider.notifier)
              .setRole(types.first),
        ),
        const SizedBox(height: 32),
        DropdownButtonFormField<int>(
          items: years
              .map((year) => DropdownMenuItem(
                    value: year.item1,
                    child: Text("${year.item1}-${year.item2}"),
                  ))
              .toList(),
          value: ploegEntryForm.year,
          onChanged: ploegEntryForm.ploegType == PloegType.competitie
              ? null
              : (value) => ref
                  .read(ploegEntryCreateNotifierProvider.notifier)
                  .setYear(value),
          decoration: const InputDecoration(labelText: "Welk jaar?"),
          menuMaxHeight: dropdownMenuMaxHeight,
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        // ignore: prefer-extracting-callbacks
        onPressed: () {
          ref
              .read(ploegEntryCreateNotifierProvider.notifier)
              .createPloegEntry();
          // ignore: avoid-ignoring-return-values
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Ploeg succesvol toegevoegd'),
            backgroundColor: Colors.green,
          ));
          context.goNamed('My Groups');
        },
        icon: const Icon(Icons.save),
        label: const Text('Opslaan'),
      ),
    );
  }
}
