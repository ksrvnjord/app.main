import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/groups/group_searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class MessageHandler extends StatefulWidget {

  MessageHandler({Key? key})
      : super(key: key);

  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
