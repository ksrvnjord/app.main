import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final DateTime startTime;
  final DateTime endTime;
  final DocumentReference reservationObject;
  final String creator;
  late DateTime createdAt;

  Reservation(
    this.startTime,
    this.endTime,
    this.reservationObject,
    this.creator,
  );

  static Reservation fromJson(Map<String, dynamic> json) {
    return Reservation(
      (json['startTime'] as Timestamp).toDate(),
      (json['endTime'] as Timestamp).toDate(),
      json['object']! as DocumentReference,
      json['creatorId'].toString(),
    );
  }

  Map<String, Object> toJson() {
    return {
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'object': reservationObject,
      'creatorId': creator,
      'createdTime': Timestamp.fromDate(createdAt),
    };
  }

  @override
  String toString() {
    return 'Reservation{startTime: $startTime, endTime: $endTime, reservationObject: $reservationObject, creator: $creator}';
  }
}
