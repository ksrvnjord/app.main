import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

class ReservationsQuery {
  final DateTime date;
  final DocumentReference<ReservationObject> docRef;

  ReservationsQuery(this.date, this.docRef);
}
