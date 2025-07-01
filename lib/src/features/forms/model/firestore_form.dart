import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/forms/api/firestorm_filler_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form_question.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';

part 'firestore_form.g.dart';

// If you're testing set this to 'testforms', for production use 'forms'
const String firestoreFormCollectionName = 'forms';

@immutable
@JsonSerializable()
class FirestoreForm {
  const FirestoreForm({
    required this.createdTimeTimeStamp,
    required this.title,
    this.questions = const [],
    this.formContentObjectIds = const [],
    this.questionsMap = const {},
    this.fillers = const {},
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
    this.isV2 = false,
  });
  factory FirestoreForm.fromJson(Map<String, dynamic> json) =>
      _$FirestoreFormFromJson(json);

  final String title;

  @JsonKey(toJson: _questionsToJson)
  final List<FirestoreFormQuestion> questions;

  final List<int> formContentObjectIds;

  @JsonKey(toJson: _questionsMapToJson)
  final Map<int, FirestoreFormQuestion> questionsMap;

  @JsonKey(toJson: _fillersToJson, fromJson: _fillersFromJson)
  final Map<int, FirestoreFormFillerNotifier> fillers;

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
  bool get isKoco =>
      authorName.toLowerCase().replaceAll(' ', '') == 'kookcommissie';

  final List<int> visibleForGroups;

  final String? groupId;
  final bool isDraft;

  /// **Database field**
  ///
  /// Use !isOpen in code.
  final bool isClosed;

  final bool hasMaximumNumberOfAnswers;
  final int maximumNumberOfAnswers;
  final int currentNumberOfAnswers;
  final bool maximumNumberIsVisible;
  final bool isV2;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSoldOut =>
      hasMaximumNumberOfAnswers &&
      currentNumberOfAnswers >= maximumNumberOfAnswers;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isOpen =>
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

  static Map<String, dynamic> _questionsMapToJson(
    Map<int, FirestoreFormQuestion> questions,
  ) =>
      questions.map((key, value) => MapEntry(key.toString(), value.toJson()));

  static Map<int, FirestoreFormFillerNotifier> _fillersFromJson(
    Map<String, dynamic> json,
  ) {
    return json.map((key, value) =>
        MapEntry(int.parse(key), FirestoreFormFillerNotifier.fromJson(value)));
  }

  static Map<String, dynamic> _fillersToJson(
    Map<int, FirestoreFormFillerNotifier> fillers,
  ) {
    return fillers
        .map((key, notifier) => MapEntry(key.toString(), notifier.toJson()));
  }

  bool userIsInCorrectGroupForForm(List<int> userGroups) {
    if (visibleForGroups.isEmpty) return true;
    return userGroups.any(visibleForGroups.contains);
  }
}
