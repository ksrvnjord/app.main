import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/afschrijving_filter.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_filters_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_overview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class AllTrainingPage extends StatefulWidget {
  const AllTrainingPage({Key? key}) : super(key: key);

  @override
  State<AllTrainingPage> createState() => _AllTrainingPage();
}

class _AllTrainingPage extends State<AllTrainingPage> {
  // List of filters to apply
  List<String> _filters = [];

  late SharedPreferences _sharedPrefs;

  static const int amountOfDaysUserCanBookInAdvance =
      4; // user can book x days in the advance

  late List<AfschrijvingFilter> _selectedFilters = [];

  // Generate a list of the coming 14 days
  List<DateTime> days = List.generate(
    amountOfDaysUserCanBookInAdvance,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  void updateFilters(List<String> filters) {
    setState(() {
      _selectedFilters = filters
          .map((e) => AfschrijvingFilter(
                label: e,
                // ignore: no-equal-arguments
                type: e,
              ))
          .toList();
      _filters = filters;
    });

    _sharedPrefs.setStringList('afschrijf_filters', filters);
  }

  /// Get the filters from SharedPreferences and update the state
  Future<void> _getFiltersFromSharedPreferences() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _filters = _sharedPrefs.getStringList('afschrijf_filters') ?? [];
        _selectedFilters = _filters
            .map((e) => AfschrijvingFilter(
                  label: e,
                  // ignore: no-equal-arguments
                  type: e,
                ))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getFiltersFromSharedPreferences();
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
                .map<Widget>(
                  (date) => CalendarOverview(date: date, filters: _filters),
                )
                .toList(),
          ).expanded(),
        ].toColumn(),
      ),
    );
  }
}
