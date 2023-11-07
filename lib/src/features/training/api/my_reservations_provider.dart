import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';

import '../model/reservation.dart';

// ignore: prefer-static-class
final myReservationsProvider =
    StreamProvider<QuerySnapshot<Reservation>>((ref) {
  final String? uid = ref.watch(firebaseAuthUserProvider).value?.uid;
  if (uid == null) {
    return const Stream.empty();
  }

  final startOfToday = DateTime.now().subtract(
    Duration(
      hours: DateTime.now().hour,
      minutes: DateTime.now().minute,
      seconds: DateTime.now().second,
      milliseconds: DateTime.now().millisecond,
      microseconds: DateTime.now().microsecond,
    ),
  );

  return Reservation.firestoreConverter
      .where(
        'creatorId',
        isEqualTo: uid,
      )
      .where(
        // Show reservations booked for today and later.
        'startTime',
        isGreaterThanOrEqualTo: startOfToday,
      )
      .orderBy('startTime', descending: false)
      .snapshots();
});
