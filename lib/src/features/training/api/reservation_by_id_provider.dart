import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';

// ignore: prefer-static-class
final reservationByIdProvider =
    StreamProvider.autoDispose.family<DocumentSnapshot<Reservation>, String>(
  (ref, reservationDocumentId) => ref.watch(firebaseAuthUserProvider).value ==
          null
      ? const Stream.empty()
      : Reservation.firestoreConverter.doc(reservationDocumentId).snapshots(),
);
