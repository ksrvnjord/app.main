import 'package:json_annotation/json_annotation.dart';

part 'firestore_form_question.g.dart';

@JsonSerializable()
class FirestoreFormQuestion {
  String title;
  FormQuestionType type;
  List<String>? options;
  bool isRequired;

  FirestoreFormQuestion({
    required this.title,
    required this.type,
    required this.isRequired,
    this.options,
  });

  // Create fromJson method.
  factory FirestoreFormQuestion.fromJson(Map<String, dynamic> json) =>
      _$FirestoreFormQuestionFromJson(json);

  // Create toJson method.
  Map<String, dynamic> toJson() => _$FirestoreFormQuestionToJson(this);
}

enum FormQuestionType {
  singleChoice,
  text,
}
