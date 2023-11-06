import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';

/// Returns all events that start today or later.
// ignore: prefer-static-class
final comingEventsProvider = StreamProvider.autoDispose<QuerySnapshot<Event>>(
  (ref) {
    final now = DateTime.now();

    return Event.firestoreConverter
        .orderBy('start_time', descending: false)
        .where(
          'start_time',
          isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day),
        )
        .snapshots();
  },
);
