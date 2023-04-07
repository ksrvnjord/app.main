import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Poll {
  final String question;
  final List<String> options;
  final DateTime openUntil;
  final String? description;

  const Poll({
    required this.question,
    required this.options,
    required this.openUntil,
    this.description,
  });

  // create fromJson method
  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      question: json['question'],
      options: json['options'].cast<String>(),
      openUntil: (json['openUntil'] as Timestamp).toDate(),
      description: json.containsKey('description') ? json['description'] : null,
    );
  }

  // create toJson method
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'openUntil': openUntil.toIso8601String(),
      'description': description,
    };
  }
}