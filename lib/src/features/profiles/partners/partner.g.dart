// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Partner _$PartnerFromJson(Map<String, dynamic> json) => Partner(
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      websiteUrl: json['websiteUrl'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$PartnerToJson(Partner instance) => <String, dynamic>{
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'websiteUrl': instance.websiteUrl,
      'description': instance.description,
      'type': instance.type,
    };
