import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationObject {
  final DocumentReference? reference;
  final String name;
  final List<String> permissions;
  final String type;
  final bool available;
  final String? comment;

  const ReservationObject(
    this.reference,
    this.name,
    this.permissions,
    this.type,
    this.available,
    this.comment
  );

  ReservationObject.fromJson(Map<String, Object?> json)
      : this(
          json['reference'] as DocumentReference?,
          json['name']! as String,
          (json['permissions'] as List)
              .map(((item) => item as String))
              .toList(),
          json['type']! as String,
          json['available']! as bool,
          json['comment'] as String?
        );

  Map<String, Object?> toJson() {
    return {
      'reference': reference,
      'name': name,
      'permissions': permissions,
      'type': type,
      'available': available,
      'comment': comment
    };
  }
}
