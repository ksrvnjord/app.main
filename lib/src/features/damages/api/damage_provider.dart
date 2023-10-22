import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final damageProvider =
    StreamProvider.family<DocumentSnapshot<Damage>, Tuple2<String, String>>(
  (ref, pair) {
    final reservationObjectId = pair.item1;
    final damageId = pair.item2;

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
    StreamProvider.family<QuerySnapshot<Damage>, String>(
  (ref, reservationObjectId) => FirebaseFirestore.instance
      .collection("reservationObjects")
      .doc(reservationObjectId)
      .collection("damages")
      .withConverter<Damage>(
        fromFirestore: (snapshot, _) => Damage.fromJson(snapshot.data() ?? {}),
        toFirestore: (reservation, _) => reservation.toJson(),
      )
      .snapshots(),
);
