// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_django_relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupDjangoRelation _$GroupDjangoRelationFromJson(Map<String, dynamic> json) =>
    GroupDjangoRelation(
      id: json['id'] as int,
      user: GroupDjangoUser.fromJson(json['user'] as Map<String, dynamic>),
      role: json['role'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GroupDjangoRelationToJson(
        GroupDjangoRelation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'role': instance.role,
      'permissions': instance.permissions,
    };
