import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class FormAnswer {
  final String userId;
  final String? answer; // User can choose to not answer.
  final DateTime answeredAt;
  final List<String>? allergies;

  const FormAnswer({
    required this.userId,
    required this.answer,
    required this.answeredAt,
    this.allergies,
  });

  // Create fromJson method.
  factory FormAnswer.fromJson(Map<String, dynamic> json) {
    return FormAnswer(
      userId: json['userId'],
      answer: json['answer'],
      answeredAt: (json['answeredAt'] as Timestamp).toDate(),
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answer': answer,
      'answeredAt': Timestamp.fromDate(answeredAt),
      if (allergies != null) 'allergies': allergies,
    };
  }

  // Create static method that adds a form answer to Firestore.
}
