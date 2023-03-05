import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<DocumentSnapshot<Damage>> getDamage(
  String reservationObjectId,
  String damageId,
) async {
  return await db
      .collection("reservationObjects")
      .doc(reservationObjectId)
      .collection("damages")
      .withConverter<Damage>(
        fromFirestore: (snapshot, _) => Damage.fromJson(snapshot.data()!),
        toFirestore: (reservation, _) => reservation.toJson(),
      )
      .doc(damageId)
      .get();
}
