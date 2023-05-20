import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:tuple/tuple.dart';

final damageProvider =
    FutureProvider.autoDispose.family<Damage?, Tuple2<String, String>>(
  (ref, pair) async {
    final reservationObjectId = pair.item1;
    final damageId = pair.item2;
    final DocumentSnapshot<Damage> damage = await FirebaseFirestore.instance
        .collection("reservationObjects")
        .doc(reservationObjectId)
        .collection("damages")
        .withConverter<Damage>(
          fromFirestore: (snapshot, _) =>
              Damage.fromJson(snapshot.data() ?? {}),
          toFirestore: (reservation, _) => reservation.toJson(),
        )
        .doc(damageId)
        .get();

    return damage.data();
  },
);
