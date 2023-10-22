import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

// ignore: prefer-static-class
final reservationObjectProvider =
    StreamProvider.family<DocumentSnapshot<ReservationObject>, String>(
  (ref, documentId) {
    return FirebaseFirestore.instance
        .collection('reservationObjects')
        .withConverter<ReservationObject>(
          fromFirestore: (snapshot, _) =>
              ReservationObject.fromJson(snapshot.data() ?? {}),
          toFirestore: (reservationObject, _) => reservationObject.toJson(),
        )
        .doc(documentId)
        .snapshots();
  },
);
