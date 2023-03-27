import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_made_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/model/reservations_query.dart';
import '../calendar_measurement.dart';

final CollectionReference<Reservation> reservationRef = FirebaseFirestore
    .instance
    .collection('reservations')
    .withConverter<Reservation>(
      fromFirestore: (snapshot, _) => Reservation.fromJson(snapshot.data()!),
      toFirestore: (reservation, _) => reservation.toJson(),
    );

// write a FutureProvider that returns a query snapshot of reservations for a given object

final reservationsProvider =
    FutureProvider.family<QuerySnapshot<Reservation>, ReservationsQuery>((
  ref,
  query,
) {
  ref.watch(
    reservationMadeProvider,
  ); // reload reservations when a new reservation is made
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

  return reservationRef
      .where('object', isEqualTo: query.docRef)
      .where('startTime', isGreaterThanOrEqualTo: start)
      .where('startTime', isLessThanOrEqualTo: end)
      .get(const GetOptions(source: Source.server));
});
