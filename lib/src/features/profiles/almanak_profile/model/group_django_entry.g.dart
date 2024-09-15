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
    );

Map<String, dynamic> _$GroupDjangoEntryToJson(GroupDjangoEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group.toJson(),
      'role': instance.role,
    };
