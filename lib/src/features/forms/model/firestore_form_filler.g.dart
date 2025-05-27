// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_form_filler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreFormFiller _$FirestoreFormFillerFromJson(Map<String, dynamic> json) =>
    FirestoreFormFiller(
      index: (json['index'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      hasImage: json['hasImage'] as bool,
    );

Map<String, dynamic> _$FirestoreFormFillerToJson(
        FirestoreFormFiller instance) =>
    <String, dynamic>{
      'index': instance.index,
      'title': instance.title,
      'body': instance.body,
      'hasImage': instance.hasImage,
    };
