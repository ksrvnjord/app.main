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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> filterList =
        ref.watch(reservationTypeFiltersListProvider);
    const double yourFiltersLPadding = 8;
    const double yourFiltersRPadding = 4;
    const double filterLabelSize = 12;

    return DefaultTabController(
      length: days.length,
      animationDuration:
          const Duration(milliseconds: 1726 ~/ 2), // no need to explain this
      child: Scaffold(
        floatingActionButton: Stack(children: [
          FloatingActionButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowFiltersPage(),
            )),
            tooltip: "Kies afschrijf filters",
            backgroundColor: Colors.lightBlue,
            foregroundColor: // depend on if filters selected
                filterList.isNotEmpty ? Colors.orangeAccent : Colors.white,
            child: const Icon(Icons.filter_list_alt),
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
            labelColor: Colors.white,
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            unselectedLabelColor: Colors.white60,
            indicator: const BoxDecoration(
              // color: Colors.grey[50],
              border: // white border around the selected tab
                  Border.fromBorderSide(
                BorderSide(color: Colors.white, width: 1),
              ),
              borderRadius: BorderRadius.all(Radius.circular(40)),
              shape: BoxShape.rectangle,
            ),
            indicatorPadding: const EdgeInsets.all(4),
            indicatorWeight: 0,
            tabs: days
                .map<Widget>(
                  (e) => Tab(
                    text: DateFormat('EEEE d MMM', 'nl_NL').format(e),
                  ),
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
