// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreForm _$FirestoreFormFromJson(Map<String, dynamic> json) =>
    FirestoreForm(
      createdTimeTimeStamp: const TimestampDateTimeConverter()
          .fromJson(json['createdTime'] as Timestamp),
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) =>
                  FirestoreFormQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      formContentObjectIds: (json['formContentObjectIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      questionsMap: (json['questionsMap'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(int.parse(k),
                FirestoreFormQuestion.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      fillers: json['fillers'] == null
          ? const {}
          : FirestoreForm._fillersFromJson(
              json['fillers'] as Map<String, dynamic>),
      openUntilTimeStamp: const TimestampDateTimeConverter()
          .fromJson(json['openUntil'] as Timestamp),
      description: json['description'] as String?,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      visibleForGroups: (json['visibleForGroups'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      groupId: json['groupId'] as String?,
      isDraft: json['isDraft'] as bool? ?? false,
      isClosed: json['isClosed'] as bool? ?? false,
      hasMaximumNumberOfAnswers:
          json['hasMaximumNumberOfAnswers'] as bool? ?? false,
      maximumNumberOfAnswers:
          (json['maximumNumberOfAnswers'] as num?)?.toInt() ?? 100000,
      currentNumberOfAnswers:
          (json['currentNumberOfAnswers'] as num?)?.toInt() ?? 0,
      maximumNumberIsVisible: json['maximumNumberIsVisible'] as bool? ?? false,
      formAnswersAreUnretractable:
          json['formAnswersAreUnretractable'] as bool? ?? false,
      isV2: json['isV2'] as bool? ?? false,
    );

Map<String, dynamic> _$FirestoreFormToJson(FirestoreForm instance) =>
    <String, dynamic>{
      'title': instance.title,
      'questions': FirestoreForm._questionsToJson(instance.questions),
      'formContentObjectIds': instance.formContentObjectIds,
      'questionsMap': FirestoreForm._questionsMapToJson(instance.questionsMap),
      'fillers': FirestoreForm._fillersToJson(instance.fillers),
      'openUntil': const TimestampDateTimeConverter()
          .toJson(instance.openUntilTimeStamp),
      'createdTime': const TimestampDateTimeConverter()
          .toJson(instance.createdTimeTimeStamp),
      'description': instance.description,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'visibleForGroups': instance.visibleForGroups,
      'groupId': instance.groupId,
      'isDraft': instance.isDraft,
      'isClosed': instance.isClosed,
      'hasMaximumNumberOfAnswers': instance.hasMaximumNumberOfAnswers,
      'maximumNumberOfAnswers': instance.maximumNumberOfAnswers,
      'currentNumberOfAnswers': instance.currentNumberOfAnswers,
      'maximumNumberIsVisible': instance.maximumNumberIsVisible,
      'formAnswersAreUnretractable': instance.formAnswersAreUnretractable,
      'isV2': instance.isV2,
    };
