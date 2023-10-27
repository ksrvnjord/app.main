import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class FirestoreForm {
  final String formName;
  final List<Map<String, dynamic>> questions;
  final DateTime openUntil;
  final String? description;

  const FirestoreForm({
    required this.formName,
    required this.questions,
    required this.openUntil,
    this.description,
  });

  // Create fromJson method.
  factory FirestoreForm.fromJson(Map<String, dynamic> json) {
    return FirestoreForm(
      formName: json['FormName'],
      questions: List<Map<String, dynamic>>.from(json['Vragen']),
      openUntil: (json['OpenUntil'] as Timestamp).toDate(),
      description: json['Description'],
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {};
  }
}
