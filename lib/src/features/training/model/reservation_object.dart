import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationObject {
  static final firestoreConverter = FirebaseFirestore.instance
      .collection('reservationObjects')
      .withConverter<ReservationObject>(
        fromFirestore: (snapshot, _) =>
            ReservationObject.fromJson(snapshot.data() ?? {}),
        toFirestore: (_, __) => {},
      );

  final DocumentReference? reference;
  final String name;
  final List<String> permissions;
  final String type;
  final bool available;
  final String? comment;
  final String? kind;
  final int? year;
  final String? brand;
  final bool critical;

  const ReservationObject({
    this.reference,
    required this.name,
    required this.permissions,
    required this.type,
    required this.available,
    this.comment,
    this.kind,
    this.year,
    this.brand,
    this.critical = false,
  });

  ReservationObject.fromJson(Map<String, Object?> json)
      : reference = json['reference'] as DocumentReference?,
        name = json['name']! as String,
        permissions = (json['permissions'] as List)
            .map(((item) => item as String))
            .toList(),
        type = json['type']! as String,
        available = json['available']! as bool,
        comment = json['comment'] as String?,
        kind = json['kind'] as String?,
        year = json['year'] as int?,
        brand = json['brand'] as String?,
        critical = (json['critical'] as bool?) ?? false;

  Map<String, Object?> toJson() {
    return {
      'reference': reference,
      'name': name,
      'permissions': permissions,
      'type': type,
      'available': available,
      'comment': comment,
      'kind': kind,
      'year': year,
      'brand': brand,
      'critical': critical,
    };
  }
}
