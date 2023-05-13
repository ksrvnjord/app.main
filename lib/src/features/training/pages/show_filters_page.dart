// create Stateful page that lists all available filters for a reservation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/filters/model/boat_types.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:styled_widget/styled_widget.dart';

import '../api/reservation_object_type_filters_notifier.dart';

class ShowFiltersPage extends ConsumerWidget {
  ShowFiltersPage({
    Key? key,
  }) : super(key: key);

  final Map<String, List<MultiSelectItem<String?>>>
      availableFilters = // build a map of categories and their types
      reservationObjectTypes.map((category, types) => MapEntry(
            category,
            types
                .map((type) => MultiSelectItem<String?>(
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

    final Map<String, Color> categoryColors = {
      'Binnen': Colors.blue,
      '1 roeier': Colors.red,
      '2 roeiers': Colors.orange,
      '4 roeiers': Colors.green,
      '8 roeiers': Colors.purple,
      'Overig': Colors.grey,
    };

    const double categoryPadding = 8;
    const double pagePadding = 8;
    const double headerFontSize = 20;
    const int cardBackgroundColorAlpha = 120;
    const double selectableAreaHeight = 56;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies filters'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(pagePadding),
        children: [
          // Make a MultiSelectChipField for each category in availableFilters dynamically
          ...availableFilters.keys
              .map(
                (String key) => [
                  MultiSelectChipField<String?>(
                    scroll: false,
                    decoration: const BoxDecoration(),
                    items: availableFilters[key] ?? [],
                    title: Text(key)
                        .fontSize(headerFontSize)
                        .fontWeight(FontWeight.bold),
                    headerColor: Colors.transparent,
                    chipShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    selectedChipColor: categoryColors[key],
                    textStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    // chipWidth: 80,
                    showHeader: true,
                    initialValue: activeFilters[key] ?? [],
                    onTap: (values) => ref
                        .read(reservationTypeFiltersProvider.notifier)
                        .updateFiltersForCategory(
                          key,
                          values.whereType<String>().toList(),
                        ),
                  ).card(
                    elevation: 0,
                    color: categoryColors[key]!
                        .withAlpha(cardBackgroundColorAlpha),
                    margin: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: categoryPadding),
                ].toColumn(),
              )
              .toList(),
        ],
      ),
    );
  }
}
