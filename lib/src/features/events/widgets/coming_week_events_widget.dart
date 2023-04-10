import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/widget_header.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/events.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/fade_bottom_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'upcoming_event_widget.dart';

class ComingWeekEventsWidget extends StatelessWidget {
  const ComingWeekEventsWidget({super.key});

  final double cardHeight = 104;

  @override
  Widget build(BuildContext context) {
    GraphQLClient client = Provider.of<GraphQLModel>(context).client;
    final eventsData = events(client);

    return Column(
      children: [
        WidgetHeader(
          title: "Opkomende evenementen",
          onTapName: "Agenda",
          onTap: () => Routemaster.of(context).push('events'),
        ),
        SizedBox(
          height: cardHeight,
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: FutureWrapper(
              future: eventsData,
              success: buildUpcomingEvents,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUpcomingEvents(events) {
    // remove null values of events
    events.removeWhere((event) => event == null);

    // convert events to a list of Event
    List<Event> eventsIt = events
        .map<Event>((event) => Event(
              title: event!.title!,
              startTime: DateTime.parse(event.start_time!),
              endTime: DateTime.parse(event.end_time!),
            ))
        .toList();

    // sort events by start time
    eventsIt.sort((a, b) => a.startTime.compareTo(b.startTime));

    List<Event> comingEvents = eventsIt
        .where(
          (element) => element.startTime.isAfter(DateTime.now()),
        )
        .toList();

    const int maxComingEvents = 10;

    return FadeBottomWidget(
      parentHeight: cardHeight,
      child: ListView.builder(
        itemCount: comingEvents.length >= maxComingEvents
            ? maxComingEvents
            : comingEvents.length,
        itemBuilder: (context, index) {
          Event event = comingEvents[index];
          const double elementPadding = 4;

          return UpcomingEventWidget(
            elementPadding: elementPadding,
            event: event,
          ).paddingDirectional(horizontal: elementPadding);
        },
      ),
    );
  }
}
