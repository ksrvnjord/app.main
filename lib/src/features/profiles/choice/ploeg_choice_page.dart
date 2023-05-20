import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_type_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_year_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class PloegChoicePage extends ConsumerWidget {
  const PloegChoicePage({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGender = ref.watch(ploegGeslachtFilterProvider);
    final ploegType = ref.watch(ploegTypeProvider);
    final ploegYear = ref.watch(ploegYearProvider);
    final ploegen = ref.watch(ploegenProvider);

    const double ploegenHeaderFontSize = 24;
    const double titleShimmerPadding = 128;
    const double titleShimmerHeight = 18;

    const int startYear = 1874;
    final List<int> years = List.generate(
      DateTime.now().year - startYear,
      (index) =>
          // '2022-2023', '2021-2022', ...
          DateTime.now().year - index - 1,
    );

    const double menuMaxHeight = 240;
    const double filtersHorizontalPadding = 8;

    final buttonBackground = MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.blue
            : Colors.blue.shade100);
    final buttonForeground = MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.white
            : Colors.blueGrey);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Kies een ploeg'),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.lightBlue,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        children: [
          [
            SegmentedButton<PloegType>(
                segments: [
                  for (final ploegType in PloegType.values)
                    ButtonSegment(
                        value: ploegType, label: Text(ploegType.value))
                ],
                selected: {
                  ploegType
                },
                onSelectionChanged: (types) =>
                    ref.read(ploegTypeProvider.notifier).state = types.first,
                style: ButtonStyle(
                    backgroundColor: buttonBackground,
                    foregroundColor: buttonForeground)),
            const SizedBox(height: 8),
            if (ploegType == PloegType.competitie)
              [
                SegmentedButton<Gender>(
                        segments: [
                      for (final gender in Gender.values)
                        ButtonSegment(value: gender, label: Text(gender.value))
                    ],
                        selected: {
                      selectedGender
                    },
                        onSelectionChanged: (types) => ref
                            .read(ploegGeslachtFilterProvider.notifier)
                            .state = types.first,
                        style: ButtonStyle(
                            backgroundColor: buttonBackground,
                            foregroundColor: buttonForeground))
                    .expanded(),
                DropdownButton<int>(
                    items: years
                        .map((year) => DropdownMenuItem(
                            value: year, child: Text("$year-${year + 1}")))
                        .toList(),
                    value: ploegYear,
                    onChanged: (value) =>
                        ref.read(ploegYearProvider.notifier).state = value!,
                    menuMaxHeight: menuMaxHeight),
              ].toRow(
                separator: const SizedBox(width: 48),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            const SizedBox(height: 16),
            const Text("Ploegen").fontSize(ploegenHeaderFontSize),
          ]
              .toColumn(crossAxisAlignment: CrossAxisAlignment.stretch)
              .padding(horizontal: filtersHorizontalPadding),
          ploegen.when(
            data: (data) => [
              data.isEmpty
                  ? const Text("Geen ploegen gevonden").center()
                  : const SizedBox(),
              ...data
                  .map(
                    (ploeg) => ListTile(
                      title: Text(ploeg),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      ),
                      // ignore: prefer-extracting-callbacks
                      onTap: () => Routemaster.of(context).push(ploeg),
                    ),
                  )
                  .toList(),
            ].toColumn(),
            error: (error, _) =>
                ErrorCardWidget(errorMessage: error.toString()),
            loading: () => List.generate(
              // ignore: no-magic-number
              10,
              (index) => ListTile(
                title: ShimmerWidget(
                  child: Container(
                      decoration: ShapeDecoration(
                          color: Colors.grey[300],
                          shape: const RoundedRectangleBorder()),
                      height: titleShimmerHeight),
                ).padding(right: titleShimmerPadding),
                trailing: const ShimmerWidget(
                  child: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ),
              ),
            ).toColumn(),
          ),
        ],
      ),
    );
  }
}
