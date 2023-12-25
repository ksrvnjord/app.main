import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_question_answer.dart';

@immutable
class FormAnswer {
  final String userId;
  final List<FormQuestionAnswer> answers; // User can choose to not answer.
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
      // ignore: avoid-dynamic
      answers: (json['answers'] as List<dynamic>)
          .map((e) => FormQuestionAnswer.fromJson(e))
          .toList(),
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
      'answers': answers.map((e) => e.toJson()).toList(),
      'answeredAt': Timestamp.fromDate(answeredAt),
      if (allergies != null) 'allergies': allergies,
    };
  }

  static CollectionReference<FormAnswer> firestoreConvert(String formPath) =>
      FirebaseFirestore.instance.collection('$formPath/answers').withConverter(
            fromFirestore: (snapshot, _) =>
                FormAnswer.fromJson(snapshot.data() ?? {}),
            toFirestore: (answer, _) => answer.toJson(),
          );
}