import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/comparator_order.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/afschrijving_filter.dart';
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
    const double filterHeight = 56;
    const double filterTilePadding = 8;

    return SizedBox(
      height: filterHeight,
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
                      ? ComparatorOrder.preserve // if both (un)selected
                      : (aSelected
                          ? ComparatorOrder.aFirst
                          : ComparatorOrder.bFirst);
                });

                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: availableFilters
                      .map<Widget>((filter) => CalendarFilterTile(
                            label: filter.description,
                            selected: selectedFilters.contains(filter.type),
                            onPressed: () => toggleFilter(filter.type),
                          ).padding(all: filterTilePadding))
                      .toList(),
                );
              },
            );
          } else {
            return const ErrorCardWidget(
              errorMessage:
                  'Er is iets misgegaan met het ophalen van de filters',
            );
          }
        },
      ),
    );
  }
}
