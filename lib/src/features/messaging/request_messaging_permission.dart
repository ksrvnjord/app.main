import 'package:firebase_messaging/firebase_messaging.dart';

// ignore: prefer-static-class
void requestMessagingPermission() async {
  final messaging = FirebaseMessaging.instance;

  // ignore: avoid-ignoring-return-values
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}
