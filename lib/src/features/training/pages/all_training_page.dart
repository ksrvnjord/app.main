import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  // Generate a list of the coming 14 days
  List<DateTime> days = List.generate(
    amountOfDaysUserCanBookInAdvance,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  void updateFilters(List<String> filters) {
    setState(() {
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
    const double yourFiltersLPadding = 8;
    const double yourFiltersRPadding = 4;

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
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowFiltersPage(
                      parentUpdate: updateFilters,
                    ),
                  )),
                  icon: const Icon(Icons.filter_list_alt),
                ),
                if (_filters.isNotEmpty)
                  const Positioned(
                    top: 10,
                    right: 8,
                    child: // show a white dot if there are filters applied
                        Icon(
                      Icons.circle,
                      size: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
              ],
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
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              shape: BoxShape.rectangle,
            ),
            indicatorPadding: const EdgeInsets.all(4),
            indicatorWeight: 0,
            tabs: days
                .map<Widget>(
                  (e) => Tab(icon: null, text: DateFormat('E d MMM').format(e)),
                )
                .toList(),
          ),
        ),
        body: [
          Container(
            color: Colors.lightBlue,
            // width: double.infinity,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text(
                    'Je selectie:',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ).padding(
                    right: yourFiltersRPadding,
                    left: yourFiltersLPadding,
                  ),
                  ..._filters
                      .map<Widget>(
                        (filter) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Chip(
                            backgroundColor: Colors.grey[300],
                            label: Text(filter),
                            labelStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            // padding: const EdgeInsets.all(0),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
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
