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
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FirestoreFormQuestionToJson(
        FirestoreFormQuestion instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': const FormQuestionTypeConverter().toJson(instance.type),
      'options': instance.options,
      'isRequired': instance.isRequired,
    };
