import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';

// ignore: prefer-static-class
final reservationByIdProvider =
    FutureProvider.family<DocumentSnapshot<Reservation>, String>(
  (ref, reservationDocumentId) => FirebaseFirestore.instance
      .collection('reservations')
      .withConverter(
        fromFirestore: (snapshot, _) => Reservation.fromJson(
          snapshot.data() ?? {},
        ),
        toFirestore: (reservation, _) => reservation.toJson(),
      )
      .doc(reservationDocumentId)
      .get(),
);
