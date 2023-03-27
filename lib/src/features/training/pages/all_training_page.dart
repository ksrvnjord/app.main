import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_type_filters_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/show_filters_page.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_overview.dart';
import 'package:styled_widget/styled_widget.dart';

class AllTrainingPage extends ConsumerWidget {
  AllTrainingPage({Key? key}) : super(key: key);

  static const int amountOfDaysUserCanBookInAdvance =
      4; // user can book x days in the advance

  // Generate a list of the coming 14 days
  final List<DateTime> days = List.generate(
    amountOfDaysUserCanBookInAdvance,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  static const double yourFiltersLPadding = 8;
  static const double yourFiltersRPadding = 4;
  static const double filterLabelSize = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> filterList =
        ref.watch(reservationTypeFiltersListProvider);

    return DefaultTabController(
      length: days.length,
      child: Scaffold(
        floatingActionButton: Stack(children: [
          FloatingActionButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowFiltersPage(),
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
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
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
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowFiltersPage(),
                )),
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
                              backgroundColor: Colors.lightBlue,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              label: Text(filter),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: filterLabelSize,
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
          ),
          TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: days
                .map<Widget>(
                  (date) => CalendarOverview(date: date),
                )
                .toList(),
          ).expanded(),
        ].toColumn(),
      ),
    );
  }
}
