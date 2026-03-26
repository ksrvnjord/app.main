import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/notifications/model/birthday_message.dart';

final receivedBirthdayMessagesProvider =
    StreamProvider.family<List<BirthdayMessage>, String>((ref, uid) {
  if (uid.isEmpty) {
    return Stream.value(const <BirthdayMessage>[]);
  }

  final currentYear = DateTime.now().year.toString();

  return FirebaseFirestore.instance
      .collection('people')
      .doc(uid)
      .collection('birthday_messages')
      .doc(currentYear)
      .collection('messages')
      .orderBy('sentAt', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => BirthdayMessage.fromMap(doc.data()))
        .toList();
  });
});
