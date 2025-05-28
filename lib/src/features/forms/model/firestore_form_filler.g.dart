// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_form_filler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirestoreFormFiller _$FirestoreFormFillerFromJson(Map<String, dynamic> json) =>
    FirestoreFormFiller(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      hasImage: json['hasImage'] as bool,
    );

Map<String, dynamic> _$FirestoreFormFillerToJson(
        FirestoreFormFiller instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'hasImage': instance.hasImage,
    };
