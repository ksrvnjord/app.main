import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class FormAnswer {
  final String userId;
  final List<Map<String, dynamic>>? answers; // User can choose to not answer.
  final DateTime answeredAt;
  final List<String>? allergies;

  const FormAnswer({
    required this.userId,
    required this.answers,
    required this.answeredAt,
    this.allergies,
  });

  // Create fromJson method.
  factory FormAnswer.fromJson(Map<String, dynamic> json) {
    return FormAnswer(
      userId: json['userId'],
      answers: json['answers'],
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
      'answers': answers,
      'answeredAt': Timestamp.fromDate(answeredAt),
      if (allergies != null) 'allergies': allergies,
    };
  }

  // Create static method that adds a form answer to Firestore.
}
