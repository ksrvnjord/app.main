import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_question_answer.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';

part 'form_answer.g.dart';

@immutable
@JsonSerializable()
class FormAnswer {
  static const isCompletedJSONKey = "isCompleted";

  final String userId;

  @JsonKey(toJson: _answersToJson)
  final List<FormQuestionAnswer> answers; // User can choose to not answer.

  @TimestampDateTimeConverter()
  final Timestamp answeredAt;

  @JsonKey(name: isCompletedJSONKey)
  final bool isCompleted;

  // ignore: sort_constructors_first
  const FormAnswer({
    required this.userId,
    required this.answers,
    required this.answeredAt,
    required this.isCompleted,
  });

  // Create fromJson method.
  // ignore: sort_constructors_first
  factory FormAnswer.fromJson(Map<String, dynamic> json) =>
      _$FormAnswerFromJson(json);

  // Create toJson method.
  Map<String, dynamic> toJson() => _$FormAnswerToJson(this);

  static CollectionReference<FormAnswer> firestoreConvert(String formPath) =>
      FirebaseFirestore.instance.collection('$formPath/answers').withConverter(
            fromFirestore: (snapshot, _) =>
                FormAnswer.fromJson(snapshot.data() ?? {}),
            toFirestore: (answer, _) => answer.toJson(),
          );

  static List<Map<String, dynamic>> _answersToJson(
    List<FormQuestionAnswer> answers,
  ) =>
      answers.map((answer) => answer.toJson()).toList();
}
