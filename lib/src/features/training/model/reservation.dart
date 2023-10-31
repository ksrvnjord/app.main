import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  @JsonKey(
    toJson: _documentReferenceToJson,
    fromJson: _documentReferenceFromJson,
  )
  final DocumentReference reservationObject;
  final String creatorId;

  final String objectName;
  final String creatorName;

  @JsonKey(name: "startTime")
  @TimestampDateTimeConverter()
  final Timestamp startTimestamp;

  @JsonKey(name: "endTime")
  @TimestampDateTimeConverter()
  final Timestamp endTimestamp;

  @JsonKey(name: "createdAt")
  @TimestampDateTimeConverter()
  final Timestamp createdAtTimestamp = Timestamp.now();

  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime get startTime => startTimestamp.toDate();
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime get endTime => endTimestamp.toDate();
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime get createdAt => createdAtTimestamp.toDate();

  Reservation({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.reservationObject,
    required this.creatorId,
    required this.objectName,
    required this.creatorName,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);

  static DocumentReference _documentReferenceFromJson(
    DocumentReference documentReference,
  ) =>
      documentReference;

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
