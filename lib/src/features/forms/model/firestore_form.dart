import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';

@immutable
class FirestoreForm {
  final String formName;
  final List<FirestoreFormQuestion> questions;
  final DateTime openUntil;
  final String? description;

  static final CollectionReference<FirestoreForm> firestoreConvert =
      FirebaseFirestore.instance.collection('forms').withConverter(
            fromFirestore: (snapshot, _) =>
                FirestoreForm.fromJson(snapshot.data() ?? {}),
            toFirestore: (answer, _) => answer.toJson(),
          );

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
      // ignore: avoid-dynamic
      questions: (json['Vragen'] as List<dynamic>)
          .map((vraag) => FirestoreFormQuestion.fromJson(vraag))
          .toList(),
      openUntil: (json['OpenUntil'] as Timestamp).toDate(),
      description: json['Description'],
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {
      'FormName': formName,
      'Vragen': questions.map((vraag) => vraag.toJson()).toList(),
      'OpenUntil': Timestamp.fromDate(openUntil),
      if (description != null) 'Description': description,
    };
  }
}
