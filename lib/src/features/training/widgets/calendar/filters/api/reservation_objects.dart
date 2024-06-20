import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_favorites_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_type_filters_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

// ignore: prefer-static-class
final availableReservationObjectsProvider =
    StreamProvider<QuerySnapshot<ReservationObject>>((ref) {
  final filters = ref.watch(reservationTypeFiltersListProvider);

  final showFavorites = ref.watch(showFavoritesProvider);
  if (showFavorites) {
    final favorites = ref.watch(favoriteObjectsProvider);

    // TODO: retrieve all favorites.
    return ReservationObject.firestoreConverter
        .where("name", whereIn: favorites)
        .orderBy('name')
        .snapshots();
  }

  return ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : filters.isEmpty
          ? ReservationObject.firestoreConverter
              .where('available', isEqualTo: true)
              .orderBy('name')
              .snapshots()
          : ReservationObject.firestoreConverter
              .where('type', whereIn: filters)
              .where('available', isEqualTo: true)
              .orderBy('name')
              .snapshots();
});

// ignore: prefer-static-class
final sortedAvailableReservationObjectProvider =
    StreamProvider.autoDispose((ref) async* {
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

  yield [...boatsICanReserve, ...boatsICannotReserve];
});
