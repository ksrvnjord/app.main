import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';

part 'firestore_form.g.dart';

@immutable
@JsonSerializable()
class FirestoreForm {
  final String title;

  @JsonKey(toJson: _questionsToJson)
  final List<FirestoreFormQuestion> questions;

  @TimestampDateTimeConverter()
  final Timestamp openUntil;
  @TimestampDateTimeConverter()
  final Timestamp createdTime;

  final String? description;
  final String authorId;
  final String authorName;
  final List<int?>? visibleForGroups;
  final List<String?>? visibleForGroupsString;

  static final CollectionReference<FirestoreForm> firestoreConvert =
      FirebaseFirestore.instance.collection('testforms').withConverter(
            // TODO testform: "testforms"this is used for debugging original is "forms".
            fromFirestore: (snapshot, _) =>
                FirestoreForm.fromJson(snapshot.data() ?? {}),
            toFirestore: (form, _) => form.toJson(),
          );

  // ignore: sort_constructors_first
  const FirestoreForm({
    required this.createdTime,
    required this.title,
    required this.questions,
    required this.openUntil,
    this.description,
    required this.authorId,
    required this.authorName,
    this.visibleForGroups,
    this.visibleForGroupsString,
  });

  // Create fromJson method.
  // ignore: sort_constructors_first
  factory FirestoreForm.fromJson(Map<String, dynamic> json) =>
      _$FirestoreFormFromJson(json);

  // Create toJson method.
  Map<String, dynamic> toJson() => _$FirestoreFormToJson(this);
  static List<Map<String, dynamic>> _questionsToJson(
    List<FirestoreFormQuestion> questions,
  ) =>
      questions.map((question) => question.toJson()).toList();
}
