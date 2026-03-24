import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Birthday message data model
class BirthdayMessage {

  BirthdayMessage({
    required this.id,
    required this.senderId,
    required this.senderFullName,
    required this.message,
    required this.title,
    required this.sentAt,
  });

  final String id;
  final String senderId;
  final String senderFullName;
  final String message;
  final String title;
  final DateTime sentAt;

  factory BirthdayMessage.fromJson(Map<String, dynamic> json, String id) {
    return BirthdayMessage(
      id: id,
      senderId: json['senderId'] as String? ?? '',
      senderFullName: json['senderFullName'] as String? ?? 'Lid',
      message: json['message'] as String? ?? '',
      title: json['title'] as String? ?? '',
      sentAt: (json['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

/// Fetch all birthday messages for current user for the current year
final birthdayMessagesProvider =
    StreamProvider.family<List<BirthdayMessage>, String>((ref, uid) {
  if (uid.isEmpty) {
    return Stream.value([]);
  }

  final currentYear = DateTime.now().year;

  return FirebaseFirestore.instance
      .collection('people')
      .doc(uid)
      .collection('birthday_messages')
      .doc(currentYear.toString())
      .collection('messages')
      .orderBy('sentAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => BirthdayMessage.fromJson(
                  doc.data(),
                  doc.id,
                ))
            .toList();
      });
});

/// Count unread birthday messages (those sent but not marked read by receiver)
final unreadBirthdayMessagesCountProvider =
    StreamProvider.family<int, String>((ref, uid) {
  if (uid.isEmpty) {
    return Stream.value(0);
  }

  final currentYear = DateTime.now().year;

  return FirebaseFirestore.instance
      .collection('people')
      .doc(uid)
      .collection('birthday_messages')
      .doc(currentYear.toString())
      .collection('messages')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});
