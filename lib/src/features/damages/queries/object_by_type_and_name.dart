import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

final CollectionReference<ReservationObject> reservationObjectsRef =
    FirebaseFirestore.instance
        .collection('reservationObjects')
        .withConverter<ReservationObject>(
          fromFirestore: (snapshot, _) =>
              ReservationObject.fromJson(snapshot.data()!),
          toFirestore: (reservation, _) => reservation.toJson(),
        );

Future<List<DocumentSnapshot<ReservationObject>>> objectByTypeAndName(
  String type,
  String name,
) async {
  return (await reservationObjectsRef
          .where('available', isEqualTo: true)
          .where('type', isEqualTo: type)
          .where('name', isEqualTo: name)
          .get())
      .docs
      .toList();
}
