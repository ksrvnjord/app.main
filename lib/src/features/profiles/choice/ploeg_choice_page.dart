import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/groups_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/year_selector_dropdown.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class PloegChoicePage extends ConsumerWidget {
  const PloegChoicePage({
    Key? key,
    required this.ploegYear,
    required this.ploegType,
  }) : super(
          key: key,
        );

  final int ploegYear;
  final String ploegType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ploegen = ref.watch(groupsProvider(Tuple2(ploegType, ploegYear)));

    const double titleShimmerPadding = 128;
    const double titleShimmerHeight = 18;

    const double wrapSpacing = 8;
    const double filterHPadding = 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies een ploeg'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        children: [
          [
            for (final type in ['Competitieploeg', 'Wedstrijdsectie'])
              ChoiceChip(
                label: Text(type),
                onSelected: (selected) => context.goNamed(
                  'Ploegen',
                  queryParameters: {
                    'year': ploegYear.toString(),
                    'type': type,
                  },
                ),
                selected: type == ploegType,
              ),
            [
              const Text("Kies een jaar:"),
              YearSelectorDropdown(
                onChanged: (selectedYear) => context.goNamed(
                  "Ploegen",
                  queryParameters: {
                    'year': selectedYear.toString(),
                    'type': ploegType,
                  },
                ),
                selectedYear: ploegYear,
              ),
            ].toRow(),
          ]
              .toWrap(
                spacing: wrapSpacing,
              )
              .paddingDirectional(horizontal: filterHPadding),
          ploegen.when(
            data: (data) => [
              data.isEmpty
                  ? Text("Geen $ploegType gevonden voor $ploegYear-${ploegYear + 1}")
                      .center()
                  : const SizedBox(),
              ...data
                  .map(
                    (ploeg) => ListTile(
                      title: Text(
                        ploeg.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      // ignore: prefer-extracting-callbacks
                      onTap: () => context.goNamed(
                        "Ploeg",
                        queryParameters: {
                          "year": ploegYear.toString(),
                          "type": ploegType,
                        },
                        pathParameters: {"ploeg": ploeg.name},
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
