// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'huis_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HuisInfoImpl _$$HuisInfoImplFromJson(Map<String, dynamic> json) =>
    _$HuisInfoImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      allNjord: json['allNjord'] as bool,
      composition: $enumDecode(_$HouseCompositionEnumMap, json['composition']),
      houseNumber: json['houseNumber'] as String,
      streetName: json['streetName'] as String,
      postalCode: json['postalCode'] as String,
      numberOfHousemates: (json['numberOfHousemates'] as num).toInt(),
      yearOfFoundation: (json['yearOfFoundation'] as num).toInt(),
    );

Map<String, dynamic> _$$HuisInfoImplToJson(_$HuisInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'allNjord': instance.allNjord,
      'composition': _$HouseCompositionEnumMap[instance.composition]!,
      'houseNumber': instance.houseNumber,
      'streetName': instance.streetName,
      'postalCode': instance.postalCode,
      'numberOfHousemates': instance.numberOfHousemates,
      'yearOfFoundation': instance.yearOfFoundation,
    };

const _$HouseCompositionEnumMap = {
  HouseComposition.male: 'male',
  HouseComposition.female: 'female',
  HouseComposition.mixed: 'mixed',
};
