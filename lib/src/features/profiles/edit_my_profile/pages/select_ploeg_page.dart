import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry_create_notifier.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class SelectPloegPage extends ConsumerWidget {
  const SelectPloegPage({Key? key})
      : super(
          key: key,
        ); // TODO: make this page more modular so that it can be used to find a ploeg in the almanak, as selecting a ploeg for adding to profile, by changing the route where it navigates to

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ploegEntryForm = ref.watch(ploegEntryCreateNotifierProvider);
    final ploegen = ref.watch(ploegenProvider);
    final selectedGender = ref.watch(ploegGeslachtFilterProvider);

    const double ploegenHeaderFontSize = 24;

    const int startYear = 1874;
    final List<int> years = List.generate(
      DateTime.now().year - startYear,
      (index) =>
          // '2022-2023', '2021-2022', ...
          DateTime.now().year - index - 1,
    );

    const double menuMaxHeight = 240;

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
            for (final ploegType in PloegType.values)
              ButtonSegment(
                label: Text(ploegType.value),
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
        const SizedBox(height: 8),
        if (ploegEntryForm.ploegType == PloegType.competitie)
          [
            SegmentedButton<Gender>(
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
                for (final gender in Gender.values)
                  ButtonSegment(
                    label: Text(gender.value),
                    value: gender,
                  ),
              ],
              selected: {
                selectedGender,
              },
              onSelectionChanged: (types) => ref
                  .read(ploegGeslachtFilterProvider.notifier)
                  .state = types.first,
              // ignore: no-magic-number
            ).expanded(),
            DropdownButton<int>(
              menuMaxHeight: menuMaxHeight,
              // isExpanded: true,
              value: ploegEntryForm.year,
              onChanged: (value) => ref
                  .read(ploegEntryCreateNotifierProvider.notifier)
                  .setYear(value!),
              items: years
                  .map((year) => DropdownMenuItem(
                        value: year,
                        child: Text("$year-${year + 1}"),
                        // alignment: AlignmentDirectional.center,
                      ))
                  .toList(),
              // ignore: no-magic-number
            ),
          ].toRow(
            separator: const SizedBox(width: 48),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        const SizedBox(height: 16),
        const Text("Ploegen").fontSize(ploegenHeaderFontSize),
        ploegen.isEmpty
            ? const Text("Geen ploegen gevonden").center()
            : const SizedBox(),
        ...ploegen
            .map(
              (ploeg) => ListTile(
                title: Text(ploeg),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                // ignore: prefer-extracting-callbacks
                onTap: () {
                  ref
                      .read(ploegEntryCreateNotifierProvider.notifier)
                      .setPloegName(ploeg);
                  Routemaster.of(context).push("add");
                },
              ),
            )
            .toList(),
      ]),
    );
  }
}
