import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/filters.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/filters/calendar_filter_tile.dart';
import 'package:provider/provider.dart';
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
    final client = Provider.of<GraphQLModel>(context).client;

    return SizedBox(
        height: 64,
        child: FutureWrapper(
            future: afschrijvingFilters(),
            success: (availableFilters) {
              if (availableFilters != null) {
                return FutureWrapper(
                    future: filters,
                    success: (selectedFilters) {
                      if (selectedFilters != null) {
                        return ListView(
                            scrollDirection: Axis.horizontal,
                            children: availableFilters
                                .map<Widget>((e) => CalendarFilterTile(
                                      label: e.description,
                                      selected:
                                          selectedFilters.contains(e.type),
                                      icon: e.icon,
                                      onPressed: () => toggleFilter(e.type),
                                    ).padding(all: 8))
                                .toList());
                      }
                    });
              } else {
                return const ErrorCardWidget(
                    errorMessage:
                        'Er is iets misgegaan met het ophalen van de filters');
              }
            }));
  }
}
