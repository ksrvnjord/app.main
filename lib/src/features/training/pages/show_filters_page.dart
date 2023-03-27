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
  static const Map<String, Color> categoryColors = {
    'Binnen': Colors.blue,
    '1 roeier': Colors.red,
    '2 roeiers': Colors.orange,
    '4 roeiers': Colors.green,
    '8 roeiers': Colors.purple,
    'Overig': Colors.grey,
  };
  static const double categoryPadding = 4;
  static const double selectedChipOpacity = 0.5;

  static const double categoryFontSize = 16;
  static const double pagePadding = 8;
  static const double headerFontSize = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, List<String>> activeFilters =
        ref.watch(reservationTypeFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kies filters'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(pagePadding),
        child: ListView(
          children: [
            // Make a MultiSelectChipField for each category in availableFilters dynamically
            ...availableFilters.keys
                .map(
                  (String key) => Column(
                    children: [
                      Text(key)
                          .fontSize(categoryFontSize)
                          .fontWeight(FontWeight.bold),
                      MultiSelectChipField<String?>(
                        scroll: false,
                        decoration: const BoxDecoration(),
                        items: availableFilters[key] ?? [],
                        icon: const Icon(Icons.check),
                        title: Text(key)
                            .textColor(Colors.white)
                            .fontSize(headerFontSize),
                        headerColor: categoryColors[key],
                        chipShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        // ignore: no-equal-arguments
                        chipColor: categoryColors[key],
                        selectedChipColor: categoryColors[key]!
                            .withOpacity(selectedChipOpacity),
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        showHeader: false,
                        initialValue: activeFilters[key] ?? [],
                        onTap: (values) => ref
                            .read(reservationTypeFiltersProvider.notifier)
                            .updateFiltersForCategory(
                              key,
                              values.whereType<String>().toList(),
                            ),
                      ).padding(vertical: categoryPadding),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
