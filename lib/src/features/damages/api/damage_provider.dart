import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final damageProvider = StreamProvider.autoDispose
    .family<DocumentSnapshot<Damage>, Tuple2<String, String>>(
  (ref, pair) {
    final reservationObjectId = pair.item1;
    final damageId = pair.item2;
    if (ref.watch(firebaseAuthUserProvider).value == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection("reservationObjects")
        .doc(reservationObjectId)
        .collection("damages")
        .withConverter<Damage>(
          fromFirestore: (snapshot, _) =>
              Damage.fromJson(snapshot.data() ?? {}),
          toFirestore: (reservation, _) => reservation.toJson(),
        )
        .doc(damageId)
        .snapshots();
  },
);

// ignore: prefer-static-class
final damagesForReservationObjectProvider =
    StreamProvider.autoDispose.family<QuerySnapshot<Damage>, String>(
  (ref, reservationObjectId) =>
      ref.watch(firebaseAuthUserProvider).value == null
          ? const Stream.empty()
          : FirebaseFirestore.instance
              .collection("reservationObjects")
              .doc(reservationObjectId)
              .collection("damages")
              .withConverter<Damage>(
                fromFirestore: (snapshot, _) =>
                    Damage.fromJson(snapshot.data() ?? {}),
                toFirestore: (reservation, _) => reservation.toJson(),
              )
              .snapshots(),
);
