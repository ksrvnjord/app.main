// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knrb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KNRB _$KNRBFromJson(Map<String, dynamic> json) => KNRB(
      knrb: json['knrb'] as bool,
      knrbId: json['knrb_id'] as String,
      lastSynchronized: json['last_synchronized'] == null
          ? null
          : DateTime.parse(json['last_synchronized'] as String),
      startMembership: json['start_membership'] == null
          ? null
          : DateTime.parse(json['start_membership'] as String),
    );

Map<String, dynamic> _$KNRBToJson(KNRB instance) => <String, dynamic>{
      'knrb': instance.knrb,
      'knrb_id': instance.knrbId,
      'last_synchronized': instance.lastSynchronized?.toIso8601String(),
      'start_membership': instance.startMembership?.toIso8601String(),
    };
