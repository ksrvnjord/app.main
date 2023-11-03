import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ignore: prefer-static-class
Future<void> requestMessagingPermission() async {
  final messaging = FirebaseMessaging.instance;
  try {
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
  } catch (e, stk) {
    FirebaseCrashlytics.instance.recordError(e, stk);
  }
}
