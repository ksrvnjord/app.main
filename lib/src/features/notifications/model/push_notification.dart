import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';

part 'push_notification.g.dart';

const String firestoreNotificationCollectionName = 'notifications';

@immutable
@JsonSerializable()
class PushNotification {
  const PushNotification({
    required this.title,
    required this.body,
    required this.topic,
    required this.readBy,
    required this.createdAt,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationFromJson(json);
  final String title;
  final String body;
  final String topic;
  final List<String> readBy;

  @TimestampDateTimeConverter()
  final Timestamp createdAt;

  static final CollectionReference<PushNotification> firestoreConvert =
      FirebaseFirestore.instance
          .collection(firestoreNotificationCollectionName)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                PushNotification.fromJson(snapshot.data() ?? {}),
            toFirestore: (notification, _) => notification.toJson(),
          );

  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);
}
