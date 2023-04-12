import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

final comingEventsProvider = FutureProvider<List<Event>>(
  (ref) async {
    final client = ref.watch(graphQLModelProvider).client;
    final result = await client.query$CalendarItems();
    final data = result.parsedData;
    if (data == null) {
      return [];
    }
    final maybeEvents = data.events;

    final List<Event> events = [];
    final now = DateTime.now();
    for (final Query$CalendarItems$events? event in maybeEvents) {
      if (event == null) {
        continue;
      }

      DateTime endTime = DateTime.parse(event.end_time!);
      if (endTime.isAfter(now)) {
        // only add events that are going on, or are going to happen
        events.add(Event(
          title: event.title!,
          startTime: DateTime.parse(event.start_time!),
          endTime: endTime,
        ));
      }
    }
    // sort events by start time
    events.sort((a, b) => a.startTime.compareTo(b.startTime));
    await Future.delayed(const Duration(
      milliseconds: 1726 ~/ 2,
    )); // let user feel that data is being loaded

    return events;
  },
);
