import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/comparator_order.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/filters.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/filters/calendar_filter_tile.dart';
import 'package:styled_widget/styled_widget.dart';

class CalendarFilterRow extends StatelessWidget {
  final Future<List<String>> filters;
  final void Function(String filter) toggleFilter;

  const CalendarFilterRow({
    Key? key,
    required this.filters,
    required this.toggleFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 64,
        child: FutureWrapper(
            future: afschrijvingFilters(),
            success: (availableFilters) {
              if (availableFilters != null) {
                return FutureWrapper(
                    future: filters,
                    success: (selectedFilters) {
                      Set<String> selectedFiltersSet = selectedFilters
                          .toSet(); // O(1) lookup in set vs O(n) in list

                      mergeSort(availableFilters, compare: (a, b) {
                        bool aSelected = selectedFiltersSet.contains(a.type);
                        bool bSelected = selectedFiltersSet.contains(b.type);

                        return aSelected == bSelected
                            ? Order.preserve // if both (un)selected
                            : (aSelected ? Order.aFirst : Order.bFirst);
                      });

                      return ListView(
                          scrollDirection: Axis.horizontal,
                          children: availableFilters
                              .map<Widget>((e) => CalendarFilterTile(
                                    label: e.description,
                                    selected: selectedFilters.contains(e.type),
                                    icon: e.icon,
                                    onPressed: () => toggleFilter(e.type),
                                  ).padding(all: 8))
                              .toList());
                    });
              } else {
                return const ErrorCardWidget(
                    errorMessage:
                        'Er is iets misgegaan met het ophalen van de filters');
              }
            }));
  }
}
