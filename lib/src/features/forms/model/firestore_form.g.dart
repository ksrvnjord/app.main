// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreForm _$FirestoreFormFromJson(Map<String, dynamic> json) =>
    FirestoreForm(
      createdTime: const TimestampDateTimeConverter()
          .fromJson(json['createdTime'] as Timestamp),
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => FirestoreFormQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      openUntil: const TimestampDateTimeConverter()
          .fromJson(json['openUntil'] as Timestamp),
      description: json['description'] as String?,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      isDraft: json['isDraft'] as bool?,
      hasMaximumNumberOfAnswers: json['hasMaximumNumberOfAnswers'] as bool?,
      maximumNumberOfAnswers: (json['maximumNumberOfAnswers'] as num?)?.toInt(),
      maximumNumberIsVisible: json['maximumNumberIsVisible'] as bool?,
    );

Map<String, dynamic> _$FirestoreFormToJson(FirestoreForm instance) =>
    <String, dynamic>{
      'title': instance.title,
      'questions': FirestoreForm._questionsToJson(instance.questions),
      'openUntil':
          const TimestampDateTimeConverter().toJson(instance.openUntil),
      'createdTime':
          const TimestampDateTimeConverter().toJson(instance.createdTime),
      'description': instance.description,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'isDraft': instance.isDraft,
      'hasMaximumNumberOfAnswers': instance.hasMaximumNumberOfAnswers,
      'maximumNumberOfAnswers': instance.maximumNumberOfAnswers,
      'maximumNumberIsVisible': instance.maximumNumberIsVisible,
    };
