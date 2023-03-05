import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<DocumentSnapshot<Damage>>> allDamages(
  String? reservationObjectId,
) async {
  if (reservationObjectId != null) {
    return (await db
            .collection("reservationObjects")
            .doc(reservationObjectId)
            .collection("damages")
            .withConverter<Damage>(
              fromFirestore: (snapshot, _) => Damage.fromJson(snapshot.data()!),
              toFirestore: (reservation, _) => reservation.toJson(),
            )
            .get())
        .docs;
  }

  return (await db
          .collectionGroup("damages")
          .withConverter<Damage>(
            fromFirestore: (snapshot, _) => Damage.fromJson(snapshot.data()!),
            toFirestore: (reservation, _) => reservation.toJson(),
          )
          .get())
      .docs;
}
