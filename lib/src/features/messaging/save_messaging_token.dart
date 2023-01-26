import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

void saveMessagingToken() async {
  String? token = await messaging.getToken();
  if (token == null) {
    return;
  }

  User? user = auth.currentUser;
  if (user == null) {
    return;
  }

  String userId = user.uid;

  DocumentReference<Map<String, dynamic>> tokenRef = FirebaseFirestore.instance
      .collection('people')
      .doc(userId)
      .collection('tokens')
      .doc(token);

  DocumentSnapshot<Object?> tokenDoc = await tokenRef.get();

  tokenDoc.exists
      ? tokenRef.update({'lastUsed': DateTime.now()})
      : tokenRef.set({
          'createdTime': DateTime.now(),
          'token': token,
          'device': Platform.operatingSystem,
          'lastUsed': DateTime.now()
        });

  // TODO: HACKED THIS HERE ATM, BUT NEEDS BETTER LIFECYCLE
  // ESPECIALLY WHEN WE'RE ADDING COMMITTEE-NOTIFICATIONS AND
  // SOCIAL NETWORKING
  await FirebaseMessaging.instance.subscribeToTopic(userId);
  await FirebaseMessaging.instance.subscribeToTopic("all");
}
