// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionEntry _$PermissionEntryFromJson(Map<String, dynamic> json) =>
    PermissionEntry(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PermissionEntryToJson(PermissionEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
