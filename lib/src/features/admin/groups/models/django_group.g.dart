// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'django_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DjangoGroup _$DjangoGroupFromJson(Map<String, dynamic> json) => DjangoGroup(
      id: json['id'] as int?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => GroupDjangoRelation.fromJson(e as Map<String, dynamic>))
          .toList(),
      rights: (json['rights'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      name: json['name'] as String,
      type: DjangoGroup._typeFromJson(json['type'] as String),
      year: json['year'] as int,
    );

Map<String, dynamic> _$DjangoGroupToJson(DjangoGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': DjangoGroup._typeToJson(instance.type),
      'year': instance.year,
      'rights': instance.rights,
    };
