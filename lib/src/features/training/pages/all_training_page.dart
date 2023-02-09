import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/afschrijving_filter.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_filters_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_overview.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/filters/calendar_filter_row.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class AllTrainingPage extends StatefulWidget {
  const AllTrainingPage({Key? key}) : super(key: key);

  @override
  State<AllTrainingPage> createState() => _AllTrainingPage();
}

class _AllTrainingPage extends State<AllTrainingPage> {
  // List of filters to apply
  late Future<List<String>> _filters;

  // Load SharedPreferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const int amountOfDaysUserCanBookInAdvance =
      4; // user can book x days in the advance

  late List<AfschrijvingFilter> _selectedFilters = [];

  // Generate a list of the coming 14 days
  List<DateTime> days = List.generate(
    amountOfDaysUserCanBookInAdvance,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  Future<SharedPreferences> getPrefs() async {
    return await _prefs;
  }

  void updateFilters(List<String> filters) {
    _selectedFilters = filters
        .map((e) => AfschrijvingFilter(
              label: e,
              // ignore: no-equal-arguments
              type: e,
            ))
        .toList();

    getPrefs().then((prefs) {
      setState(() {
        _filters = prefs
            .setStringList('afschrijf_filters', filters)
            .then((bool success) {
          return filters;
        });
      });
    });
  }

  void toggleFilter(String filter) {
    getPrefs().then((prefs) {
      final List<String> filters =
          (prefs.getStringList('afschrijf_filters') ?? ['Ruimtes']);

      if (filters.contains(filter)) {
        filters.remove(filter);
      } else {
        filters.add(filter);
      }

      setState(() {
        _filters = prefs
            .setStringList('afschrijf_filters', filters)
            .then((bool success) {
          return filters;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _filters = _prefs.then((SharedPreferences prefs) =>
        prefs.getStringList('afschrijf_filters') ?? ['Ruimtes']);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: days.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Afschrijven'),
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
          actions: [
            // show filter icon button to toggle filters
            IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShowFiltersPage(
                  parentUpdate: updateFilters,
                ),
              )),
              icon: const Icon(Icons.filter_list_alt),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            labelStyle: const TextStyle(fontSize: 20),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            unselectedLabelColor: Colors.white60,
            indicator: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                // Valid case to have the same radius on both sides
                // ignore: no-equal-arguments
                topRight: Radius.circular(10),
              ),
            ),
            tabs: days
                .map<Widget>(
                  (e) => Tab(icon: null, text: DateFormat('E d MMM').format(e)),
                )
                .toList(),
          ),
        ),
        body: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _selectedFilters
                  .map<Widget>(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Chip(
                        label: Text(e.type),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: days
                .map<Widget>((date) => FutureWrapper(
                      future: _filters,
                      success: (filters) =>
                          CalendarOverview(date: date, filters: filters),
                    ))
                .toList(),
          ).expanded(),
          // CalendarFilterRow(
          //   filters: _filters,
          //   toggleFilter: toggleFilter,
          // ),
        ].toColumn(),
      ),
    );
  }
}
