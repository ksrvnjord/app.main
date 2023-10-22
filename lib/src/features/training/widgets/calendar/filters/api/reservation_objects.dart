import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_type_filters_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

// ignore: prefer-static-class
final availableReservationObjectsProvider =
    StreamProvider<QuerySnapshot<ReservationObject>>((ref) {
  final filters = ref.watch(reservationTypeFiltersListProvider);

  return FirebaseFirestore.instance
      .collection('reservationObjects')
      .withConverter<ReservationObject>(
        fromFirestore: (snapshot, _) =>
            ReservationObject.fromJson(snapshot.data() ?? {}),
        toFirestore: (reservation, _) => reservation.toJson(),
      )
      .where('type', whereIn: filters)
      .where('available', isEqualTo: true)
      .orderBy('name')
      .snapshots();
});

// ignore: prefer-static-class
final sortedAvailableReservationObjectProvider = FutureProvider((ref) async {
  final availableReservationObjects =
      await ref.watch(availableReservationObjectsProvider.future);
  final token = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
  final myPermissions = token?.claims?['permissions'] ?? [];
  final myPermissionsSet = myPermissions.toSet();

  final boatsICanReserve = availableReservationObjects.docs
      .where((element) =>
          element.data().permissions.isEmpty ||
          element
              .data()
              .permissions
              .toSet()
              .intersection(myPermissionsSet)
              .isNotEmpty)
      .toList()
    ..sort((a, b) => a.data().name.compareTo(b.data().name));

  final boatsICannotReserve = availableReservationObjects.docs
      .where((element) =>
          element.data().permissions.isNotEmpty &&
          element
              .data()
              .permissions
              .toSet()
              .intersection(myPermissionsSet)
              .isEmpty)
      .toList()
    ..sort((a, b) => a.data().name.compareTo(b.data().name));

  return [...boatsICanReserve, ...boatsICannotReserve];
});
