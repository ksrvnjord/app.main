// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_django_relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupDjangoRelation _$GroupDjangoRelationFromJson(Map<String, dynamic> json) =>
    GroupDjangoRelation(
      id: (json['id'] as num).toInt(),
      user: GroupDjangoUser.fromJson(json['user'] as Map<String, dynamic>),
      role: GroupDjangoRelation._roleFromJson(json['role'] as String?),
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GroupDjangoRelationToJson(
        GroupDjangoRelation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'role': GroupDjangoRelation._roleToJson(instance.role),
      'permissions': instance.permissions,
    };
