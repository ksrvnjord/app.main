import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hasSendBirthdayMessageProvider =
    StreamProvider.family<bool, String>((ref, receiverId) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Stream.value(false);
  }

  final userId = user.uid;
  final currentYear = DateTime.now().year;

  final documentPath = '/people/$receiverId/birthday/$currentYear';

  return FirebaseFirestore.instance
      .doc(documentPath)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) {
      return false;
    }

    final data = snapshot.data();
    if (data == null || data['hasReceivedCongratulationsFrom'] == null) {
      return false;
    }

    final ids = List<String>.from(data['hasReceivedCongratulationsFrom']);
    return ids.contains(userId);
  });
});
