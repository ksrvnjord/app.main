import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final DateTime startTime;
  final DateTime endTime;
  final DocumentReference reservationObject;
  final int creator;

  const Reservation(
    this.startTime,
    this.endTime,
    this.reservationObject,
    this.creator,
  );

  Reservation.fromJson(Map<String, Object?> json)
      : this(
          DateTime.parse(json['startTime'] as String),
          DateTime.parse(json['endTime'] as String),
          json['object']! as DocumentReference,
          json['creatorId']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'object': reservationObject.path,
      'creatorId': creator,
    };
  }
}
