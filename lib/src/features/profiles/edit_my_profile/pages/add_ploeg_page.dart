import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry_create_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class AddPloegPage extends ConsumerWidget {
  const AddPloegPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ploegEntryForm = ref.watch(ploegEntryCreateNotifierProvider);

    const int startYear = 1874;
    final List<int> years = List.generate(
      DateTime.now().year - startYear,
      (index) =>
          // '2022-2023', '2021-2022', ...
          DateTime.now().year - index - 1,
    );

    const double dropdownMenuMaxHeight = 200;
    const double labelFontSize = 20;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voeg ploeg toe'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: [
        DataTextListTile(name: "Ploeg", value: ploegEntryForm.name!),
        const SizedBox(height: 32),
        const Text("Ik ben een").fontSize(labelFontSize),
        const SizedBox(height: 8),
        SegmentedButton<PloegRole>(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? Colors.blue
                    : Colors.blue.shade100),
            foregroundColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? Colors.white
                    : Colors.blueGrey),
          ),
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
        const SizedBox(height: 32),
        DropdownButtonFormField(
          menuMaxHeight: dropdownMenuMaxHeight,
          // make this field required
          decoration: const InputDecoration(
            // The asterisk is a hint to the user that this field is required
            // ignore: unnecessary_string_escapes
            labelText: "Welk jaar?",
          ),
          value: ploegEntryForm.year,
          onChanged: ploegEntryForm.ploegType == PloegType.competitie
              ? null // competitieploegen are already set for a year
              : (int? value) => ref
                  .read(ploegEntryCreateNotifierProvider.notifier)
                  .setYear(value),
          items: years
              .map((year) => DropdownMenuItem(
                    value: year,
                    child: Text("$year-${year + 1}"),
                  ))
              .toList(),
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
        backgroundColor: Colors.blue,
      ),
    );
  }
}
