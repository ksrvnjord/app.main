import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<QueryDocumentSnapshot<Damage>>> allDamages(
  String? reservationObjectId,
) async {
  var damagesQuery = db.collectionGroup("damages").withConverter<Damage>(
        fromFirestore: (snapshot, _) => Damage.fromJson(snapshot.data()!),
        toFirestore: (reservation, _) => reservation.toJson(),
      );

  if (reservationObjectId != null) {
    damagesQuery = damagesQuery.where('parent', isEqualTo: reservationObjectId);
  }

  final damages = await damagesQuery.get();

  return damages.docs;
}
