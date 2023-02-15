import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/events.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'upcoming_event_widget.dart';

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
              const double cardHeight = 96;

              return SizedBox(
                height: cardHeight,
                child: Stack(
                  children: [
                    ListView.builder(
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
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: cardHeight / 4,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.24),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
