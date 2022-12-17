import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_filters.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_show_all.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Create an empty Modal function to refresh the modal
  void Function(void Function()) setModalState = (f0) => {};

  static const int amountOfDaysUserCanBookInAdvance =
      4; // user can book x days in the advance

  // Generate a list of the coming 14 days
  List<DateTime> days = List.generate(amountOfDaysUserCanBookInAdvance,
      (index) => DateTime.now().add(Duration(days: index)));

  Future<void> _toggleFilter(String filter) async {
    final SharedPreferences prefs = await _prefs;
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
    setModalState(() => {});
  }

  @override
  void initState() {
    super.initState();
    _filters = _prefs.then((SharedPreferences prefs) {
      var fltrs = prefs.getStringList('afschrijf_filters') ?? ['Ruimtes'];
      return fltrs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: days.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Afschrijven'),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            StatefulBuilder(builder: (context, setModalState) {
                              this.setModalState = setModalState;
                              return FutureWrapper(
                                  future: _filters,
                                  success: (filters) => TrainingFilters(
                                        filters: filters ?? ['Ruimtes'],
                                        toggleFilter: _toggleFilter,
                                      ));
                            }));
                  }),
            ],
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              tabs: days
                  .map<Widget>((e) => Tab(
                      icon: const Icon(LucideIcons.chevronDown),
                      text: DateFormat('E d MMM').format(e)))
                  .toList(),
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: days
                .map<Widget>((date) => FutureWrapper(
                    future: _filters,
                    success: (filters) => TrainingShowAll(
                        key: UniqueKey(),
                        date: date,
                        filters: filters ?? ['Ruimtes'])))
                .toList(),
          ),
        ));
  }
}
