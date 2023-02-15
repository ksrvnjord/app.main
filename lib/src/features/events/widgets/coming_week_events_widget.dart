import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/events.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:intl/intl.dart';

class ComingWeekEventsWidget extends StatelessWidget {
  const ComingWeekEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    GraphQLClient client = Provider.of<GraphQLModel>(context).client;
    final eventsData = events(client);

    initializeDateFormatting('nl_NL');

    const double titleFontSize = 16;

    return Column(
      children: [
        const Text(
          "Opkomende evenementen",
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

              List<Event> comingEvents = eventsIt
                  .where(
                    (element) => element.startTime.isAfter(DateTime.now()),
                  )
                  .toList();

              const int maxComingEvents = 10;
              const double cardHeight = 104;

              return SizedBox(
                height: cardHeight,
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
            },
          ),
        ),
      ],
    );
  }
}

class UpcomingEventWidget extends StatelessWidget {
  const UpcomingEventWidget({
    super.key,
    required this.elementPadding,
    required this.event,
  });

  final double elementPadding;
  final Event event;

  @override
  Widget build(BuildContext context) {
    const double topPadding = 8;
    const double dayNumberFontSize = 24;
    DateFormat monthFormat = DateFormat('MMM EEE', 'nl_NL');
    const double dateFontSize = 12;
    DateFormat timeFormat = DateFormat('HH:mm');
    const int maxLines = 2;
    const double eventFontSize = 16;
    DateTime start = event.startTime;

    return Row(
      children: [
        Text(start.day.toString())
            .fontSize(dayNumberFontSize)
            .paddingDirectional(horizontal: elementPadding),
        Text(
          monthFormat.format(start),
        )
            .fontSize(dateFontSize)
            .textColor(Colors.blueGrey)
            .padding(top: topPadding),
        Text(timeFormat.format(start))
            .fontSize(dateFontSize)
            .textColor(Colors.blueGrey)
            .padding(horizontal: elementPadding, top: topPadding),
        Expanded(
          child: Text(
            event.title,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          )
              .fontSize(eventFontSize)
              .paddingDirectional(horizontal: elementPadding),
        ),
      ],
    );
  }
}
