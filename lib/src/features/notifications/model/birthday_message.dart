import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class BirthdayMessage {
  factory BirthdayMessage.fromMap(Map<String, dynamic> data) {
    return BirthdayMessage(
      title: (data['title'] as String?)?.trim().isNotEmpty == true
          ? (data['title'] as String)
          : 'Felicitatie',
      message: (data['message'] as String?)?.trim().isNotEmpty == true
          ? (data['message'] as String)
          : 'Gefeliciteerd!',
      senderId: (data['senderId'] as String?) ?? '',
      senderFullName: (data['senderFullName'] as String?) ?? 'Lid',
      receiverId: (data['receiverId'] as String?) ?? '',
      sentAt: (data['sentAt'] as Timestamp?) ?? Timestamp.now(),
    );
  }
  const BirthdayMessage({
    required this.title,
    required this.message,
    required this.senderId,
    required this.senderFullName,
    required this.receiverId,
    required this.sentAt,
  });

  final String title;
  final String message;
  final String senderId;
  final String senderFullName;
  final String receiverId;
  final Timestamp sentAt;
}
