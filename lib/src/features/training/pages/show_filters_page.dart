// Create Stateful page that lists all available filters for a reservation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/filters/model/boat_types.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:styled_widget/styled_widget.dart';

import '../api/reservation_object_type_filters_notifier.dart';

class ShowFiltersPage extends ConsumerWidget {
  ShowFiltersPage({super.key});

  final Map<String, List<MultiSelectItem<String>>> availableFilters =
      // Build a map of categories and their types.
      reservationObjectTypes.map((category, types) => MapEntry(
            category,
            types
                .map((type) => MultiSelectItem<String>(
                      type,
                      // ignore: no-equal-arguments
                      type,
                    ))
                .toList(),
          ));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, List<String>> activeFilters =
        ref.watch(reservationTypeFiltersProvider);

    final Map<String, MaterialColor> categoryColors = {
      'Binnen': Colors.blue,
      '1 roeier': Colors.red,
      '2 roeiers': Colors.orange,
      '4 roeiers': Colors.green,
      '8 roeiers': Colors.purple,
      'Overig': Colors.brown,
    };

    const double categoryPadding = 8;
    const double pagePadding = 8;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies filters'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(pagePadding),
        children: [
          // Make a MultiSelectChipField for each category in availableFilters dynamically.
          ...availableFilters.keys.map(
            (String key) => [
              // The MultiSelectChipField has to be of type String?, and not String because of the MultiSelectChipField package.
              MultiSelectChipField<String?>(
                items: availableFilters[key] ?? [],
                decoration: const BoxDecoration(),
                chipColor: Theme.of(context).colorScheme.surface,
                selectedChipColor:
                    Theme.of(context).brightness == Brightness.light
                        ? categoryColors[key]?.shade100
                        : categoryColors[key]?.shade900,
                textStyle: textTheme.bodyMedium,
                selectedTextStyle: Theme.of(context).textTheme.bodyMedium,
                chipShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                onTap: (values) => ref
                    .read(reservationTypeFiltersProvider.notifier)
                    .updateFiltersForCategory(
                      key,
                      values.whereType<String>().toList(),
                    ),
                title: Text(key, style: textTheme.titleLarge),
                scroll: false,
                headerColor: Colors.transparent,
                initialValue: activeFilters[key] ?? [],
                showHeader: true,
              ).padding(bottom: categoryPadding).card(
                    elevation: 0,
                  ),
            ].toColumn(separator: const SizedBox(height: categoryPadding)),
          ),
        ],
      ),
    );
  }
}
