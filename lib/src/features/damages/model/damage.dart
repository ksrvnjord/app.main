import 'package:cloud_firestore/cloud_firestore.dart';

class Damage {
  final DocumentReference? reference;
  final DocumentReference? parent;
  final String? image;
  final String description;
  final bool critical;

  const Damage({
    this.reference,
    this.parent,
    this.image,
    this.critical = false,
    required this.description,
  });

  Damage.fromJson(Map<String, Object?> json)
      : reference = json['reference'] as DocumentReference?,
        parent = json['parent'] as DocumentReference?,
        description = json['description']! as String,
        image = json['image'] as String?,
        critical = json['critical'] as bool;

  Map<String, Object?> toJson() {
    return {
      'reference': reference,
      'parent': parent,
      'image': image,
      'description': description,
      'critical': critical,
    };
  }
}
