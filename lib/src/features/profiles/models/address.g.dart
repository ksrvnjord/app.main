// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      street: json['street'] as String?,
      houseNumber: json['housenumber'] as String?,
      houseNumberAddition: json['housenumber_addition'] as String?,
      addressTwo: json['address_two'] as String?,
      postalCode: json['zipcode'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      visible: json['visible'] as bool?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street,
      'housenumber': instance.houseNumber,
      'housenumber_addition': instance.houseNumberAddition,
      'address_two': instance.addressTwo,
      'zipcode': instance.postalCode,
      'city': instance.city,
      'country': instance.country,
      'visible': instance.visible,
    };
