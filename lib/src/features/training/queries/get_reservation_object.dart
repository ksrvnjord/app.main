import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

final db = FirebaseFirestore.instance;

Future<DocumentSnapshot<ReservationObject?>> getReservationObject(
  String reservationObjectId,
) async {
  return await db
      .collection('reservationObjects')
      .withConverter<ReservationObject>(
        fromFirestore: (snapshot, _) =>
            ReservationObject.fromJson(snapshot.data()!),
        toFirestore: (reservationObject, _) => reservationObject.toJson(),
      )
      .doc(reservationObjectId)
      .get();
}