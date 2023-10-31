// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_django_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupDjangoUser _$GroupDjangoUserFromJson(Map<String, dynamic> json) =>
    GroupDjangoUser(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      identifier: json['identifier'] as int,
      id: json['id'] as int,
    );

Map<String, dynamic> _$GroupDjangoUserToJson(GroupDjangoUser instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'identifier': instance.identifier,
      'id': instance.id,
    };
