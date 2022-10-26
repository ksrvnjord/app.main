import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationObject {
  final DocumentReference reference;
  final String name;
  final List<DocumentReference> permissions;
  final DocumentReference type;

  const ReservationObject(
    this.reference,
    this.name,
    this.permissions,
    this.type,
  );

  ReservationObject.fromJson(Map<String, Object?> json)
      : this(
          json['reference']! as DocumentReference,
          json['name']! as String,
          json['permissions']! as List<DocumentReference>,
          json['type']! as DocumentReference,
        );

  Map<String, Object?> toJson() {
    return {
      'reference': reference,
      'name': name,
      'permissions': permissions,
      'type': type,
    };
  }
}
