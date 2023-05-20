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
      4; // User can book x days in the advance.

  // Generate a list of the coming 14 days.
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
      // ignore: sort_child_properties_last
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Afschrijven'),
          bottom: TabBar(
            tabs: days
                .map<Widget>((e) => Tab(
                      text: DateFormat('EEEE d MMM', 'nl_NL').format(e),
                    ))
                .toList(),
            isScrollable: true,
            indicatorWeight: 0,
            indicatorPadding: const EdgeInsets.all(4),
            indicator: const BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(color: Colors.white, width: 1),
              ),
              borderRadius: BorderRadius.all(Radius.circular(40)),
              shape: BoxShape.rectangle,
            ),
            labelColor: Colors.white,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: Colors.white60,
            unselectedLabelStyle: const TextStyle(fontSize: 14),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.lightBlue,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.lightBlue,
          ),
        ),
        body: [
          Container(
            alignment: Alignment.center,
            color: Colors.lightBlue,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GestureDetector(
                child: Row(children: [
                  if (filterList.isNotEmpty)
                    const Text(
                      'Je selectie:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ).padding(
                      right: yourFiltersRPadding,
                      left: yourFiltersLPadding,
                    ),
                  ...filterList
                      .map<Widget>((filter) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            child: Chip(
                              label: Text(filter),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: filterLabelSize,
                              ),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              backgroundColor: Colors.lightBlue,
                              visualDensity: VisualDensity.compact,
                            ),
                          ))
                      .toList(),
                ]),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShowFiltersPage(),
                  ),
                ),
              ),
            ),
          ),
          TabBarView(
            // ignore: sort_child_properties_last
            children: days
                .map<Widget>((date) => CalendarOverview(date: date))
                .toList(),
            physics: const NeverScrollableScrollPhysics(),
          ).expanded(),
        ].toColumn(),
        floatingActionButton: Stack(children: [
          FloatingActionButton(
            // ignore: sort_child_properties_last
            child: const Icon(Icons.filter_list_alt),
            tooltip: "Kies afschrijf filters",
            foregroundColor:
                filterList.isNotEmpty ? Colors.orangeAccent : Colors.white,
            backgroundColor: Colors.lightBlue,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowFiltersPage(),
            )),
          ),
        ]),
      ),
      animationDuration: const Duration(milliseconds: 1726 ~/ 2),
    );
  }
}
