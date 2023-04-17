import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/reservation.dart';

final CollectionReference<Reservation> reservationsRef = FirebaseFirestore
    .instance
    .collection('reservations')
    .withConverter<Reservation>(
      fromFirestore: (snapshot, _) => Reservation.fromJson(snapshot.data()!),
      toFirestore: (reservation, _) => reservation.toJson(),
    );

final myReservationsProvider =
    StreamProvider.autoDispose<QuerySnapshot<Reservation>>(
  (ref) => reservationsRef
      .where(
        'creatorId',
        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
      )
      .where(
        'startTime',
        isGreaterThanOrEqualTo: DateTime.now().subtract(const Duration(
          hours: 24,
        )),
      )
      .orderBy('startTime', descending: false)
      .snapshots(),
);
