// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormAnswer _$FormAnswerFromJson(Map<String, dynamic> json) => FormAnswer(
      userId: json['userId'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => FormQuestionAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      answeredAt: const TimestampDateTimeConverter()
          .fromJson(json['answeredAt'] as Timestamp),
      isCompleted: json['isCompleted'] as bool,
    );

Map<String, dynamic> _$FormAnswerToJson(FormAnswer instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'answers': FormAnswer._answersToJson(instance.answers),
      'answeredAt':
          const TimestampDateTimeConverter().toJson(instance.answeredAt),
      'isCompleted': instance.isCompleted,
    };
