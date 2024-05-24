import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class PollAnswer {
  final String userId;
  final String? answer; // User can choose to not answer.
  final DateTime answeredAt;
  final List<String>? allergies;

  // Create fromJson method.
  // ignore: sort_constructors_first
  factory PollAnswer.fromJson(Map<String, dynamic> json) {
    return PollAnswer(
      userId: json['userId'],
      answer: json['answer'],
      answeredAt: (json['answeredAt'] as Timestamp).toDate(),
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
    );
  }

  // ignore: sort_constructors_first
  const PollAnswer({
    required this.userId,
    required this.answer,
    required this.answeredAt,
    this.allergies,
  });
  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answer': answer,
      'answeredAt': Timestamp.fromDate(answeredAt),
      if (allergies != null) 'allergies': allergies,
    };
  }

  // Create static method that adds a poll answer to Firestore.
}
