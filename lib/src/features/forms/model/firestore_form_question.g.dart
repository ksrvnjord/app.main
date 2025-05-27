// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_form_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreFormQuestion _$FirestoreFormQuestionFromJson(
        Map<String, dynamic> json) =>
    FirestoreFormQuestion(
      title: json['title'] as String,
      type: const FormQuestionTypeConverter().fromJson(json['type'] as String),
      isRequired: json['isRequired'] as bool,
      index: (json['index'] as num?)?.toInt(),
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$FirestoreFormQuestionToJson(
        FirestoreFormQuestion instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': const FormQuestionTypeConverter().toJson(instance.type),
      'options': instance.options,
      'isRequired': instance.isRequired,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'index': instance.index,
    };
