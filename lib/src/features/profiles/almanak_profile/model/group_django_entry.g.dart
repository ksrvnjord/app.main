// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_django_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupDjangoEntry _$GroupDjangoEntryFromJson(Map<String, dynamic> json) =>
    GroupDjangoEntry(
      id: json['id'] as int,
      group: DjangoGroup.fromJson(json['group'] as Map<String, dynamic>),
      role: json['role'] as String?,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GroupDjangoEntryToJson(GroupDjangoEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'role': instance.role,
      'permissions': instance.permissions,
    };
