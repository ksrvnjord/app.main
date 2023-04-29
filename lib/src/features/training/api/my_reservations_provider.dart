import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

import '../model/reservation.dart';

final myReservationsProvider =
    StreamProvider<QuerySnapshot<Reservation>>((ref) {
  final String? uid = ref.watch(firebaseAuthUserProvider)?.uid;
  if (uid == null) {
    return const Stream.empty();
  }

  final CollectionReference<Reservation> reservationsRef = FirebaseFirestore
      .instance
      .collection('reservations')
      .withConverter<Reservation>(
        fromFirestore: (snapshot, _) => Reservation.fromJson(snapshot.data()!),
        toFirestore: (reservation, _) => reservation.toJson(),
      );

  return reservationsRef
      .where(
        'creatorId',
        isEqualTo: uid,
      )
      .where(
        'startTime',
        isGreaterThanOrEqualTo:
            DateTime.now().subtract(const Duration(days: 1)),
      )
      .orderBy('startTime', descending: false)
      .snapshots();
});
