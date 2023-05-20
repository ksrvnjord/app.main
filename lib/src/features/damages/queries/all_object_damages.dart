import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';

Future<List<DocumentSnapshot<Damage>>> allObjectDamages(
  String reservationObjectId,
) async {
  return (await FirebaseFirestore.instance
          .collection("reservationObjects")
          .doc(reservationObjectId)
          .collection("damages")
          .withConverter<Damage>(
            fromFirestore: (snapshot, _) =>
                Damage.fromJson(snapshot.data() ?? {}),
            toFirestore: (reservation, _) => reservation.toJson(),
          )
          .get())
      .docs;
}
