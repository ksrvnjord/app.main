import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final DateTime startTime;
  final DateTime endTime;
  final DocumentReference reservationObject;
  final String creator;
  late DateTime createdAt;
  late String objectName;
  late String creatorName;

  Reservation(
    this.startTime,
    this.endTime,
    this.reservationObject,
    this.creator,
    this.objectName, {
    required this.creatorName,
  });

  static Reservation fromJson(Map<String, dynamic> json) {
    return Reservation(
      (json['startTime'] as Timestamp).toDate(),
      (json['endTime'] as Timestamp).toDate(),
      json['object']! as DocumentReference,
      json['creatorId'].toString(),
      json['objectName'].toString(),
      creatorName: json['creatorName'].toString(),
    );
  }

  Map<String, Object> toJson() {
    Map<String, Object> map = {
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'object': reservationObject,
      'creatorId': creator,
      'createdTime': Timestamp.fromDate(createdAt),
      'objectName': objectName,
    };

    if (creatorName != null) {
      map['creatorName'] = creatorName!;
    }

    return map;
  }

  @override
  String toString() {
    return 'Reservation{startTime: $startTime, endTime: $endTime, reservationObject: $reservationObject, creator: $creator, createdAt: $createdAt, objectName: $objectName, creatorName: $creatorName}';
  }
}
