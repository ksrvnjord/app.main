// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_question_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormQuestionAnswer _$FormQuestionAnswerFromJson(Map<String, dynamic> json) =>
    FormQuestionAnswer(
      questionTitle: json['questionTitle'] as String?,
      questionId: (json['questionId'] as num?)?.toInt(),
      answer: json['answer'] as String?,
    );

Map<String, dynamic> _$FormQuestionAnswerToJson(FormQuestionAnswer instance) =>
    <String, dynamic>{
      'questionTitle': instance.questionTitle,
      'questionId': instance.questionId,
      'answer': instance.answer,
    };
