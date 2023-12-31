import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';

@immutable
class FirestoreForm {
  final String formName;
  final List<FirestoreFormQuestion> questions;
  final DateTime openUntil;
  final DateTime createdTime;
  final String? description;
  final String authorId;

  static final CollectionReference<FirestoreForm> firestoreConvert =
      FirebaseFirestore.instance.collection('forms').withConverter(
            fromFirestore: (snapshot, _) =>
                FirestoreForm.fromJson(snapshot.data() ?? {}),
            toFirestore: (form, _) => form.toJson(),
          );

  const FirestoreForm({
    required this.createdTime,
    required this.formName,
    required this.questions,
    required this.openUntil,
    this.description,
    required this.authorId,
  });

  // Create fromJson method.
  factory FirestoreForm.fromJson(Map<String, dynamic> json) {
    return FirestoreForm(
      createdTime: (json['createdTime'] as Timestamp).toDate(),
      formName: json['formName'],
      questions: (json['questions'] as List)
          .map((vraag) =>
              FirestoreFormQuestion.fromJson(vraag as Map<String, dynamic>))
          .toList(),
      openUntil: (json['openUntil'] as Timestamp).toDate(),
      description: json['description'],
      authorId: json['authorId'],
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {
      'formName': formName,
      'openUntil': Timestamp.fromDate(openUntil),
      'questions': questions.map((vraag) => vraag.toJson()).toList(),
      if (description != null) 'description': description,
      'authorId': authorId,
      'createdTime': Timestamp.fromDate(createdTime),
    };
  }
}
