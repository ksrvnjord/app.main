import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> toggleTopicFCM({
  required String topic,
  required bool value,
}) async {
  final instance = FirebaseMessaging.instance;
  final cache = await Hive.openBox<bool>('topics');

  if (value) {
    await instance.subscribeToTopic(topic);
  } else {
    await instance.unsubscribeFromTopic(topic);
  }

  cache.put(topic, value);
}
