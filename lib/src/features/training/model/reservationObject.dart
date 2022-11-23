import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationObject {
  final DocumentReference reference;
  final String name;
  final List<DocumentReference> permissions;
  final String type;
  final bool available;

  const ReservationObject(
    this.reference,
    this.name,
    this.permissions,
    this.type,
    this.available,
  );

  ReservationObject.fromJson(Map<String, Object?> json)
      : this(
          json['reference']! as DocumentReference,
          json['name']! as String,
          json['permissions']! as List<DocumentReference>,
          json['type']! as String,
          json['available']! as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'reference': reference,
      'name': name,
      'permissions': permissions,
      'type': type,
      'available': available,
    };
  }
}
