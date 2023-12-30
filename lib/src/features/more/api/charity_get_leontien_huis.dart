import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
final leontienhuisProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance
      .collection('charity')
      .doc('leontienhuis')
      .snapshots();
});
