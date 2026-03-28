// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormTicket _$FormTicketFromJson(Map<String, dynamic> json) => FormTicket(
      createdAt: const TimestampDateTimeConverter()
          .fromJson(json['createdAt'] as Timestamp),
      name: json['name'] as String,
      orginalOwner: json['orginalOwner'] as String,
      owner: json['owner'] as String,
      validFrom: const TimestampDateTimeConverter()
          .fromJson(json['validFrom'] as Timestamp),
      validUntil: const TimestampDateTimeConverter()
          .fromJson(json['validUntil'] as Timestamp),
      fromForm: json['fromForm'] as String,
      fromFormAnswer: json['fromFormAnswer'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$FormTicketToJson(FormTicket instance) =>
    <String, dynamic>{
      'createdAt':
          const TimestampDateTimeConverter().toJson(instance.createdAt),
      'name': instance.name,
      'orginalOwner': instance.orginalOwner,
      'owner': instance.owner,
      'validFrom':
          const TimestampDateTimeConverter().toJson(instance.validFrom),
      'validUntil':
          const TimestampDateTimeConverter().toJson(instance.validUntil),
      'fromForm': instance.fromForm,
      'fromFormAnswer': instance.fromFormAnswer,
      'status': instance.status,
    };
