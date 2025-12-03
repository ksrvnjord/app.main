// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'django_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DjangoUser _$DjangoUserFromJson(Map<String, dynamic> json) => DjangoUser(
      id: (json['id'] as num).toInt(),
      isSuperuser: json['is_superuser'] as bool,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      infix: json['infix'] as String,
      email: json['email'] as String,
      isStaff: json['is_staff'] as bool,
      birthDate: json['birth_date'] as String?,
      initials: json['initials'] as String,
      iban: json['iban'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
      knrb: json['knrb'] == null
          ? null
          : KNRB.fromJson(json['knrb'] as Map<String, dynamic>),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => PermissionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      identifier: (json['iid'] as num).toInt(),
      groups: (json['groups'] as List<dynamic>)
          .map((e) => GroupDjangoEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DjangoUserToJson(DjangoUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_superuser': instance.isSuperuser,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'infix': instance.infix,
      'email': instance.email,
      'is_staff': instance.isStaff,
      'iid': instance.identifier,
      'birth_date': instance.birthDate,
      'iban': instance.iban,
      'initials': instance.initials,
      'address': instance.address,
      'contact': instance.contact,
      'knrb': instance.knrb,
      'info': instance.info,
      'groups': instance.groups,
      'permissions': instance.permissions,
    };
