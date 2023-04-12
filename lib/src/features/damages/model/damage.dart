import 'package:cloud_firestore/cloud_firestore.dart';

class Damage {
  final DocumentReference? reference;
  final DocumentReference parent;
  final String? image;
  final String name;
  final String type;
  final String creatorId;
  final String cause;
  final DateTime createdTime;
  final String description;
  final bool critical;
  final bool active;

  const Damage({
    this.reference,
    this.image,
    this.critical = false,
    this.active = false,
    this.cause = '',
    required this.parent,
    required this.description,
    required this.createdTime,
    required this.creatorId,
    required this.name,
    required this.type,
  });

  Damage.fromJson(Map<String, Object?> json)
      : reference = json['reference'] as DocumentReference?,
        parent = json['parent']! as DocumentReference,
        image = json['image'] as String?,
        name = (json['name'] ?? '') as String,
        type = (json['type'] ?? '') as String,
        creatorId = json['creatorId']! as String,
        createdTime = (json['createdTime'] as Timestamp).toDate(),
        description = json['description']! as String,
        cause = (json['cause'] ?? '') as String,
        critical = (json['critical'] ?? false) as bool,
        active = (json['active'] ?? false) as bool;

  Map<String, Object?> toJson() {
    return {
      'reference': reference,
      'image': image,
      'critical': critical,
      'active': active,
      'parent': parent,
      'description': description,
      'cause': cause,
      'createdTime': createdTime,
      'creatorId': creatorId,
      'name': name,
      'type': type,
    };
  }
}
