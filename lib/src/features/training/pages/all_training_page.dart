import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_type_filters_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_filters_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_overview.dart';
import 'package:styled_widget/styled_widget.dart';

class AllTrainingPage extends ConsumerStatefulWidget {
  const AllTrainingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AllTrainingPage> createState() => _AllTrainingPage();
}

class _AllTrainingPage extends ConsumerState<AllTrainingPage> {
  static const int amountOfDaysUserCanBookInAdvance =
      4; // user can book x days in the advance

  // Generate a list of the coming 14 days
  List<DateTime> days = List.generate(
    amountOfDaysUserCanBookInAdvance,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> activeFilters =
        ref.watch(reservationTypeFiltersProvider);

    List<String> filterList = activeFilters.values.expand((e) => e).toList();

    const double yourFiltersLPadding = 8;
    const double yourFiltersRPadding = 4;
    const double filterLabelSize = 12;

    return DefaultTabController(
      length: days.length,
      child: Scaffold(
        floatingActionButton: Stack(children: [
          FloatingActionButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ShowFiltersPage(),
            )),
            tooltip: "Kies afschrijf filters",
            backgroundColor: Colors.lightBlue,
            child: const Icon(Icons.filter_list_alt),
          ),
          if (filterList.isNotEmpty)
            // show a red badge if there are filters selected, don't show the amount of filters
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
              ),
            ),
        ]),
        appBar: AppBar(
          title: const Text('Afschrijven'),
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
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
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (filterList.isNotEmpty)
                    const Text(
                      'Je selectie:',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ).padding(
                      right: yourFiltersRPadding,
                      left: yourFiltersLPadding,
                    ),
                  ...filterList
                      .map<Widget>(
                        (filter) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Chip(
                            backgroundColor: Colors.grey[300],
                            label: Text(filter),
                            labelStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: filterLabelSize,
                              fontWeight: FontWeight.w400,
                            ),
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
                  (date) => CalendarOverview(date: date, filters: filterList),
                )
                .toList(),
          ).expanded(),
        ].toColumn(),
      ),
    );
  }
}
