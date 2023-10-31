// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      startTimestamp: const TimestampDateTimeConverter()
          .fromJson(json['startTime'] as Timestamp),
      endTimestamp: const TimestampDateTimeConverter()
          .fromJson(json['endTime'] as Timestamp),
      reservationObject: Reservation._documentReferenceFromJson(
          json['object'] as DocumentReference<Object?>),
      creatorId: json['creatorId'] as String,
      objectName: json['objectName'] as String,
      creatorName: json['creatorName'] as String,
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'object':
          Reservation._documentReferenceToJson(instance.reservationObject),
      'creatorId': instance.creatorId,
      'objectName': instance.objectName,
      'creatorName': instance.creatorName,
      'startTime':
          const TimestampDateTimeConverter().toJson(instance.startTimestamp),
      'endTime':
          const TimestampDateTimeConverter().toJson(instance.endTimestamp),
    };
