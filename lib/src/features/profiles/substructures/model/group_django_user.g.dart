// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_django_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupDjangoUser _$GroupDjangoUserFromJson(Map<String, dynamic> json) =>
    GroupDjangoUser(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      infix: json['infix'] as String? ?? "",
      iid: (json['iid'] as num).toInt(),
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GroupDjangoUserToJson(GroupDjangoUser instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'infix': instance.infix,
      'iid': instance.iid,
      'permissions': instance.permissions,
    };
