import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

// ignore: prefer-static-class
Future<List<DocumentSnapshot<ReservationObject>>> objectByTypeAndName(
  String type,
  String name,
) async {
  final snapshot = await ReservationObject.firestoreConverter
      .where('available', isEqualTo: true)
      .where('type', isEqualTo: type)
      .where('name', isEqualTo: name)
      .get();

  return snapshot.docs;
}
