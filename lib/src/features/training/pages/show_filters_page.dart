// create Stateful page that lists all available filters for a reservation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/filters/model/boat_types.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class ShowFiltersPage extends StatefulWidget {
  final Function parentUpdate;

  const ShowFiltersPage({
    Key? key,
    required this.parentUpdate,
  }) : super(key: key);

  @override
  State<ShowFiltersPage> createState() => _ShowFiltersPage();
}

class _ShowFiltersPage extends State<ShowFiltersPage> {
  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();
  late SharedPreferences _sharedPrefs;

  late List<String> _selectedFilters = [];
  final Map<String, List<String>> _activeFiltersMap = {};

  Future<void> _getFiltersFromPrefs() async {
    // retrieve the filters from SharedPreferences
    _sharedPrefs = await _prefsFuture;

    if (mounted) {
      setState(() {
        List<String> filters =
            _sharedPrefs.getStringList('afschrijf_filters') ?? [];
        _selectedFilters = filters;
        // place the filters in the correct category
        for (final category in reservationObjectTypes.entries) {
          String key = category.key;
          List<String> values = category.value;
          _activeFiltersMap[key] = [];

          for (final filter in filters) {
            if (values.contains(filter)) {
              _activeFiltersMap[key]?.add(filter);
            }
          }
        }
      });
    }
  }

  void updateFilters(String category, List<String> filters) {
    setState(() {
      _activeFiltersMap[category] = filters;
      _selectedFilters = _activeFiltersMap.values.expand((e) => e).toList();
      widget.parentUpdate(_selectedFilters);
    });
  }

  @override
  void initState() {
    super.initState();
    _getFiltersFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    const double pagePadding = 8;
    const double headerFontSize = 16;

    Map<String, List<MultiSelectItem<String?>>> availableFilters =
        reservationObjectTypes.map((key, value) => MapEntry(
              key,
              value
                  .map((filter) => MultiSelectItem<String?>(
                        filter,
                        // ignore: no-equal-arguments
                        filter,
                      ))
                  .toList(),
            ));

    const double chipHeight = 64;
    const double categoryPadding = 4;
    const double selectedChipOpacity = 0.5;

    Map<String, Color> categoryColors = {
      'Binnen': Colors.blue,
      '1 roeier': Colors.red,
      '2 roeiers': Colors.orange,
      '4 roeiers': Colors.green,
      '8 roeiers': Colors.purple,
      'Overig': Colors.grey,
    };

    const double categoryFontSize = 16;

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
                        initialValue: _activeFiltersMap[key] ?? [],
                        onTap: (values) => updateFilters(
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
