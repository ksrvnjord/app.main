import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';

part 'firestore_form.g.dart';

// If you're testing set this to 'testforms', for production use 'forms'
const String firestoreFormCollectionName = 'testforms';

@immutable
@JsonSerializable()
class FirestoreForm {
  // Create fromJson method
  factory FirestoreForm.fromJson(Map<String, dynamic> json) =>
      _$FirestoreFormFromJson(json);
  final String? id; // <-- New: Firestore document ID

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
  @JsonKey(defaultValue: <int>[])
  final List<int> visibleForGroups;
  final String? groupId;

  final bool? isDraft;

  @JsonKey(defaultValue: false)
  final bool isClosed;

  final bool? hasMaximumNumberOfAnswers;
  final int? maximumNumberOfAnswers;
  final bool? maximumNumberIsVisible;

  static final CollectionReference<FirestoreForm> firestoreConvert =
      FirebaseFirestore.instance
          .collection(firestoreFormCollectionName)
          .withConverter<FirestoreForm>(
            fromFirestore: (snapshot, _) =>
                FirestoreForm.fromJson(snapshot.data() ?? {})
                    .copyWith(id: snapshot.id),
            toFirestore: (form, _) => form.toJson(),
          );

  // ignore: sort_constructors_first
  const FirestoreForm({
    this.id, // <-- New: Add to constructor
    required this.createdTime,
    required this.title,
    required this.questions,
    required this.openUntil,
    this.description,
    required this.authorId,
    required this.authorName,
    this.visibleForGroups = const <int>[],
    this.groupId,
    this.isDraft,
    this.isClosed = false,
    this.hasMaximumNumberOfAnswers,
    this.maximumNumberOfAnswers,
    this.maximumNumberIsVisible,
  });

  // Create toJson method
  Map<String, dynamic> toJson() => _$FirestoreFormToJson(this);

  // Used for serializing list of questions
  static List<Map<String, dynamic>> _questionsToJson(
    List<FirestoreFormQuestion> questions,
  ) =>
      questions.map((question) => question.toJson()).toList();

  // Returns true if any of the userGroups match visibleForGroups
  bool userIsInCorrectGroupForForm(List<int> userGroups) {
    if (visibleForGroups.isEmpty) return true;
    return userGroups.any(visibleForGroups.contains);
  }

  // Used to add Firestore ID after deserialization
  FirestoreForm copyWith({
    String? id,
  }) {
    return FirestoreForm(
      id: id ?? this.id,
      createdTime: createdTime,
      title: title,
      questions: questions,
      openUntil: openUntil,
      description: description,
      authorId: authorId,
      authorName: authorName,
      visibleForGroups: visibleForGroups,
      groupId: groupId,
      isDraft: isDraft,
      isClosed: isClosed,
      hasMaximumNumberOfAnswers: hasMaximumNumberOfAnswers,
      maximumNumberOfAnswers: maximumNumberOfAnswers,
      maximumNumberIsVisible: maximumNumberIsVisible,
    );
  }
}
