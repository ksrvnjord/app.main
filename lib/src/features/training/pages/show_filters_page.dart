// create Stateful page that lists all available filters for a reservation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class ShowFiltersPage extends StatefulWidget {
  const ShowFiltersPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowFiltersPage> createState() => _ShowFiltersPage();
}

class _ShowFiltersPage extends State<ShowFiltersPage> {
  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();
  late SharedPreferences _sharedPrefs;
  // List of filters active
  List<String> _filters = [];

  Future<void> _getFiltersFromPrefs() async {
    // retrieve the filters from SharedPreferences
    _sharedPrefs = await _prefsFuture;

    if (mounted) {
      setState(() {
        _filters = _sharedPrefs.getStringList('afschrijf_filters') ?? [];
      });
    }
  }

  void removeFilter(String filter) {
    setState(() {
      _filters.remove(filter);
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
            const Text("Actieve filters")
                .fontSize(headerFontSize)
                .fontWeight(FontWeight.w600),
            Wrap(
              children: _filters
                  .map((filter) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Chip(
                          label: Text(filter).textColor(Colors.white),
                          backgroundColor: Colors.lightBlue,
                          onDeleted: () => removeFilter(filter),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
