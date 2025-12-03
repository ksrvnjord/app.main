// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      blikken: (json['blikken'] as num).toInt(),
      stuurblikken: (json['stuurblikken'] as num).toInt(),
      taarten: (json['taarten'] as num).toInt(),
      dubbellid: json['dubbellid'] as bool,
      studie: json['studie'] as String?,
      educationalInstitute: json['educational_institute'] as String?,
      magazine: json['magazine'] as bool,
      otherClubs: (json['other_clubs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      otherRowingClubs: (json['other_rowing_clubs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      honorary: json['honorary'] as bool,
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'blikken': instance.blikken,
      'stuurblikken': instance.stuurblikken,
      'taarten': instance.taarten,
      'dubbellid': instance.dubbellid,
      'studie': instance.studie,
      'educational_institute': instance.educationalInstitute,
      'magazine': instance.magazine,
      'other_clubs': instance.otherClubs,
      'other_rowing_clubs': instance.otherRowingClubs,
      'honorary': instance.honorary,
    };
