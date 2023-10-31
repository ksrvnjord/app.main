// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'django_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DjangoUser _$DjangoUserFromJson(Map<String, dynamic> json) => DjangoUser(
      id: json['id'] as int,
      lichting: json['lichting'] as int,
      isSuperuser: json['is_superuser'] as bool,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      isStaff: json['is_staff'] as bool,
      zipcode: json['zipcode'] as String,
      housenumber: json['housenumber'] as String,
      housenumberAddition: json['housenumber_addition'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      phonePrimary: json['phone_primary'] as String,
      identifier: json['identifier'] as int,
    );

Map<String, dynamic> _$DjangoUserToJson(DjangoUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lichting': instance.lichting,
      'is_superuser': instance.isSuperuser,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'is_staff': instance.isStaff,
      'zipcode': instance.zipcode,
      'housenumber': instance.housenumber,
      'housenumber_addition': instance.housenumberAddition,
      'street': instance.street,
      'city': instance.city,
      'country': instance.country,
      'phone_primary': instance.phonePrimary,
      'identifier': instance.identifier,
    };
