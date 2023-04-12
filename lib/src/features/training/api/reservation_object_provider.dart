import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/queries/get_reservation_object.dart';

final reservationObjectProvider =
    FutureProvider.family<DocumentSnapshot<ReservationObject?>, String>(
  (ref, id) {
    return getReservationObject(id);
  },
);
