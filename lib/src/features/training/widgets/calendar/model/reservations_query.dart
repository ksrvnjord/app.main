import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

class ReservationsQuery {
  final DateTime date;
  final DocumentReference<ReservationObject> docRef;

  @override
  int get hashCode => date.hashCode ^ docRef.hashCode;

  ReservationsQuery(this.date, this.docRef);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReservationsQuery &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          docRef == other.docRef;
}
