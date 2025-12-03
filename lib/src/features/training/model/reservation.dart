import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  static final firestoreConverter = FirebaseFirestore.instance
      .collection('reservations')
      .withConverter<Reservation>(
        fromFirestore: (snapshot, _) =>
            Reservation.fromJson(snapshot.data() ?? {}),
        toFirestore: (_, __) => {},
      );

  @JsonKey(
    name: 'object',
    toJson: _documentReferenceToJson,
    fromJson: _documentReferenceFromJson,
  )
  final DocumentReference reservationObject;
  final String creatorId;

  final String objectName;
  final String creatorName;
  final bool? creatorIsAdmin;

  // Firestore doesn't support DateTime, so we use Timestamp instead.
  @JsonKey(name: "startTime")
  @TimestampDateTimeConverter()
  final Timestamp startTimestamp;

  @JsonKey(name: "endTime")
  @TimestampDateTimeConverter()
  final Timestamp endTimestamp;

  // We use getters so we can use DateTime instead of Timestamp in our code.
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime get startTime => startTimestamp.toDate();
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime get endTime => endTimestamp.toDate();

  // ignore: sort_constructors_first
  const Reservation({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.reservationObject,
    required this.creatorId,
    required this.objectName,
    required this.creatorName,
    this.creatorIsAdmin,
  });

  // ignore: sort_constructors_first
  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);

  static DocumentReference _documentReferenceFromJson(
    DocumentReference<Object?> docRef,
  ) =>
      docRef;

  static DocumentReference _documentReferenceToJson(
    DocumentReference documentReference,
  ) =>
      documentReference;
}

class TimestampDateTimeConverter
    implements JsonConverter<Timestamp, Timestamp> {
  const TimestampDateTimeConverter();

  @override
  Timestamp fromJson(Timestamp json) => json;

  @override
  Timestamp toJson(Timestamp object) => object;
}
