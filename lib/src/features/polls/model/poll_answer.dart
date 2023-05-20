import 'package:cloud_firestore/cloud_firestore.dart';

class PollAnswer {
  final String userId;
  final String? answer; // User can choose to not answer.
  final DateTime answeredAt;

  const PollAnswer({
    required this.userId,
    required this.answer,
    required this.answeredAt,
  });

  // Create fromJson method.
  factory PollAnswer.fromJson(Map<String, dynamic> json) {
    return PollAnswer(
      userId: json['userId'],
      answer: json['answer'],
      answeredAt: (json['answeredAt'] as Timestamp).toDate(),
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answer': answer,
      'answeredAt': Timestamp.fromDate(answeredAt),
    };
  }

  // Create static method that adds a poll answer to Firestore.
}
