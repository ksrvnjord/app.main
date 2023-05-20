import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

// ignore: prefer-static-class
Future<List<DocumentSnapshot<ReservationObject>>> objectByTypeAndName(
  String type,
  String name,
) async {
  return (await FirebaseFirestore.instance
          .collection('reservationObjects')
          .withConverter<ReservationObject>(
            fromFirestore: (snapshot, _) =>
                ReservationObject.fromJson(snapshot.data() ?? {}),
            toFirestore: (reservation, _) => reservation.toJson(),
          )
          .where('available', isEqualTo: true)
          .where('type', isEqualTo: type)
          .where('name', isEqualTo: name)
          .get())
      .docs
      .toList();
}
