import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';

/// Returns all events that start today or later.
// ignore: prefer-static-class
final comingEventsProvider = FutureProvider.autoDispose<QuerySnapshot<Event>>(
  (ref) {
    final eventsCollection = FirebaseFirestore.instance
        .collection('events')
        .withConverter<Event>(
          fromFirestore: (snapshot, _) => Event.fromMap(snapshot.data() ?? {}),
          toFirestore: (event, _) => event.toMap(),
        );

    final now = DateTime.now();

    return eventsCollection
        .orderBy('start_time', descending: false)
        .where(
          'start_time',
          isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day),
        )
        .get();
  },
);
