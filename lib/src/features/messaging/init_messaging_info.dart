import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void initMessagingInfo() async {
  AndroidInitializationSettings androidInitialize =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings iOSInitialize =
      const DarwinInitializationSettings();
  InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // TODO: Provide implementation for when initialize fails.

  // ignore: avoid-ignoring-return-values
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // ignore: avoid-ignoring-return-values
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'dbfood',
      'dbfood',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigTextStyleInformation,
      playSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );
    flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['title'],
    );
  });
}
