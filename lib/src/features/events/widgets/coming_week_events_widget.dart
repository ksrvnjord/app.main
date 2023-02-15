import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/events.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class ComingWeekEventsWidget extends StatelessWidget {
  const ComingWeekEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    GraphQLClient client = Provider.of<GraphQLModel>(context).client;
    final eventsData = events(client);

    const double titleFontSize = 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: const Text(
            "Evenementen komende week",
          ).fontSize(titleFontSize).fontWeight(FontWeight.w600),
        ),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: FutureWrapper(
            future: eventsData,
            success: (events) {
              // filter all events that are in the coming week
              Iterable<Query$CalendarItems$events?> comingWeekEvents =
                  events.where((event) {
                if (event == null || event.start_time == null) {
                  return false;
                }
                final DateTime start = DateTime.parse(event.start_time!);

                return start.isBefore(
                      DateTime.now().add(const Duration(days: 30)),
                    ) &&
                    start.isAfter(DateTime.now());
              });

              return Column(
                children: [
                  ...comingWeekEvents.map((event) {
                    return event != null
                        ? ListTile(
                            title: Text(event.title!),
                            subtitle: Text(event.start_time!),
                          )
                        : Container();
                  }),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
