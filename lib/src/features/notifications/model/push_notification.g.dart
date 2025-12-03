// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotification _$PushNotificationFromJson(Map<String, dynamic> json) =>
    PushNotification(
      title: json['title'] as String,
      body: json['body'] as String,
      topic: json['topic'] as String,
      readBy:
          (json['readBy'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: const TimestampDateTimeConverter()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$PushNotificationToJson(PushNotification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'topic': instance.topic,
      'readBy': instance.readBy,
      'createdAt':
          const TimestampDateTimeConverter().toJson(instance.createdAt),
    };
