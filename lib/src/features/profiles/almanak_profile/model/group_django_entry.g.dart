// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_django_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupDjangoEntry _$GroupDjangoEntryFromJson(Map<String, dynamic> json) =>
    GroupDjangoEntry(
      id: (json['id'] as num).toInt(),
      group: DjangoGroup.fromJson(json['group'] as Map<String, dynamic>),
      role: GroupDjangoEntry._roleFromJson(json['role'] as String?),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GroupDjangoEntryToJson(GroupDjangoEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'permissions': instance.permissions,
      'role': instance.role,
    };
