import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: prefer-static-class
Future<void> saveMessagingToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return;
  }
  try {
    final String? token = await FirebaseMessaging.instance.getToken();

    final String uid = user.uid;

    DocumentReference<Map<String, dynamic>> tokenRef = FirebaseFirestore
        .instance
        .collection('people')
        .doc(uid)
        .collection('tokens')
        .doc(token);

    DocumentSnapshot<Object?> tokenDoc = await tokenRef.get();

    tokenDoc.exists
        ? tokenRef.update({'lastUsed': DateTime.now()})
        : tokenRef.set({
            'createdTime': DateTime.now(),
            'token': token,
            'device': Platform.operatingSystem,
            'lastUsed': DateTime.now(),
          });

    // Required topics to subscribe to.
    await FirebaseMessaging.instance.subscribeToTopic(uid);
    await FirebaseMessaging.instance.subscribeToTopic("all");

    // Store the subscribed topics in a local cache.
    Box cache = await Hive.openBox<bool>('topics');
    await cache.put(uid, true);
    await cache.put('all', true);
  } on Exception catch (e, stk) {
    FirebaseCrashlytics.instance.recordError(e, stk);

    return;
  }
}
