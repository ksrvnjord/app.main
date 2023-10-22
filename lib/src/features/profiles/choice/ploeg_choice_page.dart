import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_type_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/years_from_1874.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class PloegChoicePage extends ConsumerWidget {
  const PloegChoicePage({Key? key, required this.ploegYear})
      : super(
          key: key,
        );

  final int ploegYear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGender = ref.watch(ploegGeslachtFilterProvider);
    final ploegType = ref.watch(ploegTypeProvider);
    final ploegen = ref.watch(ploegenProvider(ploegYear));

    const double titleShimmerPadding = 128;
    const double titleShimmerHeight = 18;

    final List<Tuple2<int, int>> years = yearsFrom1874;

    const double menuMaxHeight = 240;
    const double filtersHorizontalPadding = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies een ploeg'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        children: [
          [
            SegmentedButton<PloegType>(
              segments: [
                for (final ploegType in PloegType.values)
                  ButtonSegment(
                    value: ploegType,
                    label: Text(ploegType.value),
                  ),
              ],
              selected: {
                ploegType,
              },
              onSelectionChanged: (types) =>
                  ref.read(ploegTypeProvider.notifier).state = types.first,
            ),
            const SizedBox(height: 8),
            if (ploegType == PloegType.competitie)
              [
                SegmentedButton<Gender>(
                  segments: [
                    for (final gender in Gender.values)
                      ButtonSegment(value: gender, label: Text(gender.value)),
                  ],
                  selected: {
                    selectedGender,
                  },
                  onSelectionChanged: (types) => ref
                      .read(ploegGeslachtFilterProvider.notifier)
                      .state = types.first,
                ).expanded(),
                DropdownButton<int>(
                  items: years
                      .map((njordYear) => DropdownMenuItem(
                            value: njordYear.item1,
                            child:
                                Text("${njordYear.item1}-${njordYear.item2}"),
                          ))
                      .toList(),
                  value: ploegYear,
                  onChanged: (value) => context.replaceNamed(
                    "Ploegen",
                    queryParameters: {"year": (value ?? ploegYear).toString()},
                  ),
                  menuMaxHeight: menuMaxHeight,
                ),
              ].toRow(
                separator: const SizedBox(width: 48),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            const SizedBox(height: 16),
            Text(
              "Ploegen",
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
                      title: Text(
                        ploeg,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      // ignore: prefer-extracting-callbacks
                      onTap: () => context.goNamed(
                        "Ploeg",
                        queryParameters: {"year": ploegYear.toString()},
                        pathParameters: {"ploeg": ploeg},
                      ),
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
                      shape: const RoundedRectangleBorder(),
                    ),
                    height: titleShimmerHeight,
                  ),
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
