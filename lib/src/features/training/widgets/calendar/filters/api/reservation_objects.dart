import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_type_filters_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

final CollectionReference<ReservationObject> reservationObjectsRef =
    FirebaseFirestore.instance
        .collection('reservationObjects')
        .withConverter<ReservationObject>(
          fromFirestore: (snapshot, _) =>
              ReservationObject.fromJson(snapshot.data()!),
          toFirestore: (reservation, _) => reservation.toJson(),
        );

// Write a FutureProvider that returns a list of ReservationObjects.
final availableReservationObjectsProvider =
    FutureProvider<QuerySnapshot<ReservationObject>>((ref) async {
  final filters = ref.watch(reservationTypeFiltersListProvider);

  return await reservationObjectsRef
      .where('type', whereIn: filters)
      .where('available', isEqualTo: true)
      .orderBy('name')
      .get();
});
