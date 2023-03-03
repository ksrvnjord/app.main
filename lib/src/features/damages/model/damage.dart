import 'package:cloud_firestore/cloud_firestore.dart';

class Damage {
  final DocumentReference? reference;
  final DocumentReference? parent;
  final String description;

  const Damage({
    this.reference,
    this.parent,
    required this.description,
  });

  Damage.fromJson(Map<String, Object?> json)
      : reference = json['reference'] as DocumentReference?,
        parent = json['parent'] as DocumentReference?,
        description = json['description']! as String;

  Map<String, Object?> toJson() {
    return {
      'reference': reference,
      'parent': parent,
      'description': description,
    };
  }
}
