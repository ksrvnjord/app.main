import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/model/reservations_query.dart';
import '../calendar_measurement.dart';

// We use a StreamProvider so that if the user makes a reservation, we don't have to query the database again as we can just listen to the stream.
// ignore: prefer-static-class
final reservationsProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<Reservation>, ReservationsQuery>((
  ref,
  query,
) {
  final date = query.date;
  final start = DateTime(
    date.year,
    date.month,
    date.day,
    CalendarMeasurement.startHour,
    0,
    0,
  );
  final end = DateTime(
    date.year,
    date.month,
    date.day,
    CalendarMeasurement.endHour,
    0,
    0,
  );

  return FirebaseFirestore.instance
      .collection('reservations')
      .withConverter<Reservation>(
        fromFirestore: (snapshot, _) =>
            Reservation.fromJson(snapshot.data() ?? {}),
        toFirestore: (reservation, _) => reservation.toJson(),
      )
      .where('object', isEqualTo: query.docRef)
      .where('startTime', isGreaterThanOrEqualTo: start)
      .where('startTime', isLessThanOrEqualTo: end)
      .snapshots();
});
