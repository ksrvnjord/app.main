import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
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
      children: [
        const Text(
          "Evenementen komende week",
        ).fontSize(titleFontSize).fontWeight(FontWeight.w600),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: FutureWrapper(
            future: eventsData,
            success: (events) {
              // remove null values of events
              events.removeWhere((event) => event == null);

              // convert events to a list of Event
              Iterable<Event> eventsIt = events.map<Event>((event) => Event(
                    title: event!.title!,
                    startTime: DateTime.parse(event.start_time!),
                    endTime: DateTime.parse(event.end_time!),
                  ));

              Iterable<Event> comingWeekEvents = eventsIt.where((element) =>
                  element.startTime.isAfter(DateTime.now()) &&
                  element.startTime.isBefore(
                    DateTime.now().add(const Duration(days: 30)),
                  ));

              return Column(
                children: [
                  ...comingWeekEvents.map((event) {
                    return ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.startTime.toIso8601String()),
                    );
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
