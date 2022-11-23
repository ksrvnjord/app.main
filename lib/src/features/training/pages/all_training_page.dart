import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_filters.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_show_all.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AllTrainingPage extends StatefulWidget {
  const AllTrainingPage({Key? key}) : super(key: key);

  @override
  State<AllTrainingPage> createState() => _AllTrainingPage();
}

class _AllTrainingPage extends State<AllTrainingPage> {
  // List of filters to apply
  List<String> filters = [];

  // Create an empty Modal function to refresh the modal
  void Function(void Function()) setModalState = (f0) => {};

  static const int amountOfDaysUserCanBookInAdvance = 4; // user can book x days in the advance

  // Generate a list of the coming 14 days
  List<DateTime> days =
      List.generate(amountOfDaysUserCanBookInAdvance, (index) => DateTime.now().add(Duration(days: index)));

  void toggleFilter(String filter) {
    if (filters.contains(filter)) {
      filters.remove(filter);
      setState(() {});
      setModalState(() {});
    } else {
      filters.add(filter);
      setState(() {});
      setModalState(() {});
    }
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
                              return TrainingFilters(
                                filters: filters,
                                toggleFilter: toggleFilter,
                              );
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
            children: days
                .map<Widget>(
                    (date) => TrainingShowAll(date: date, filters: filters))
                .toList(),
          ),
        ));
  }
}
