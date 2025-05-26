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
  const FirestoreForm({
    required this.createdTimeTimeStamp,
    required this.title,
    required this.questions,
    required this.openUntilTimeStamp,
    this.description,
    required this.authorId,
    required this.authorName,
    this.visibleForGroups = const <int>[],
    this.groupId,
    this.isDraft = false,
    this.isClosed = false,
    this.hasMaximumNumberOfAnswers = false,
    this.maximumNumberOfAnswers = 100000,
    this.currentNumberOfAnswers = 0,
    this.maximumNumberIsVisible = false,
  });
  factory FirestoreForm.fromJson(Map<String, dynamic> json) =>
      _$FirestoreFormFromJson(json);

  final String title;

  @JsonKey(toJson: _questionsToJson)
  final List<FirestoreFormQuestion> questions;

  @JsonKey(name: 'openUntil')
  @TimestampDateTimeConverter()
  final Timestamp openUntilTimeStamp;

  @JsonKey(name: 'createdTime')
  @TimestampDateTimeConverter()
  final Timestamp createdTimeTimeStamp;

  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime get openUntil => openUntilTimeStamp.toDate();
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get formClosingTimeIsInFuture => openUntil.isAfter(DateTime.now());

  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime get createdTime => createdTimeTimeStamp.toDate();

  final String? description;
  final String authorId;
  final String authorName;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isKoco => authorId == 'kookcommissie';

  final List<int> visibleForGroups;

  final String? groupId;
  final bool isDraft;

  final bool isClosed;

  final bool hasMaximumNumberOfAnswers;
  final int maximumNumberOfAnswers;
  final int currentNumberOfAnswers;
  final bool maximumNumberIsVisible;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSoldOut =>
      hasMaximumNumberOfAnswers &&
      currentNumberOfAnswers >= maximumNumberOfAnswers;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get userCanEditForm =>
      formClosingTimeIsInFuture && !isClosed && !isSoldOut && !isDraft;

  static final CollectionReference<FirestoreForm> firestoreConvert =
      FirebaseFirestore.instance
          .collection(firestoreFormCollectionName)
          .withConverter<FirestoreForm>(
            fromFirestore: (snapshot, _) =>
                FirestoreForm.fromJson(snapshot.data() ?? {}),
            toFirestore: (form, _) => form.toJson(),
          );

  Map<String, dynamic> toJson() => _$FirestoreFormToJson(this);

  static List<Map<String, dynamic>> _questionsToJson(
    List<FirestoreFormQuestion> questions,
  ) =>
      questions.map((question) => question.toJson()).toList();

  bool userIsInCorrectGroupForForm(List<int> userGroups) {
    if (visibleForGroups.isEmpty) return true;
    return userGroups.any(visibleForGroups.contains);
  }
}
