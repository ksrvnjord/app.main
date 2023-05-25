import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final DateTime startTime;
  final DateTime endTime;
  final DocumentReference reservationObject;
  final String creator;
  DateTime createdAt = DateTime.now();
  String objectName;
  String creatorName;

  Reservation(
    this.startTime,
    this.endTime,
    this.reservationObject,
    this.creator,
    this.objectName, {
    required this.creatorName,
    required this.createdAt,
  });

  static Reservation fromJson(Map<String, dynamic> json) {
    return Reservation(
      (json['startTime'] as Timestamp).toDate(),
      (json['endTime'] as Timestamp).toDate(),
      json['object']! as DocumentReference,
      json['creatorId'].toString(),
      json['objectName'].toString(),
      creatorName: json['creatorName'].toString(),
      createdAt: (json['createdTime'] as Timestamp).toDate(),
    );
  }

  Map<String, Object> toJson() => {
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'object': reservationObject,
        'creatorId': creator,
        'createdTime': Timestamp.fromDate(createdAt),
        'objectName': objectName,
        'creatorName': creatorName,
      };

  @override
  String toString() {
    return 'Reservation{startTime: $startTime, endTime: $endTime, reservationObject: $reservationObject, creator: $creator, createdAt: $createdAt, objectName: $objectName, creatorName: $creatorName}';
  }
}
