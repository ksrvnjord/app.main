import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: prefer-static-class
Future<void> toggleTopicFCM({
  required String topic,
  required bool value,
}) async {
  final cache = await Hive.openBox<bool>('topics');

  if (!kIsWeb) {
    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }
  }

  cache.put(topic, value);
}
