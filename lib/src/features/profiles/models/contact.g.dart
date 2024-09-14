// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      email: json['email'] as String,
      emailVisible: json['email_visible'] as bool,
      phonePrimary: json['phone_primary'] as String,
      phoneSecondary: json['phone_secondary'] as String?,
      phoneVisible: json['phone_visible'] as bool,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'email': instance.email,
      'email_visible': instance.emailVisible,
      'phone_primary': instance.phonePrimary,
      'phone_secondary': instance.phoneSecondary,
      'phone_visible': instance.phoneVisible,
    };
