import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationObject {
  final DocumentReference? reference;
  final String name;
  final List<String> permissions;
  final String type;
  final bool available;
  final String? comment;
  final String? kind;

  // const ReservationObject(this.reference, this.name, this.permissions,
  //     this.type, this.available, this.comment,
  //     [this.kind]);
  const ReservationObject(
      {this.reference,
      required this.name,
      required this.permissions,
      required this.type,
      required this.available,
      this.comment,
      this.kind});

  ReservationObject.fromJson(Map<String, Object?> json)
      : reference = json['reference'] as DocumentReference?,
        name = json['name']! as String,
        permissions = (json['permissions'] as List)
            .map(((item) => item as String))
            .toList(),
        type = json['type']! as String,
        available = json['available']! as bool,
        comment = json['comment'] as String?,
        kind = json['kind'] as String?;

  Map<String, Object?> toJson() {
    return {
      'reference': reference,
      'name': name,
      'permissions': permissions,
      'type': type,
      'available': available,
      'comment': comment,
      'kind': kind,
    };
  }
}
