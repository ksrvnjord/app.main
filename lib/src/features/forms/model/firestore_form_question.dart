import 'package:json_annotation/json_annotation.dart';

part 'firestore_form_question.g.dart';

@JsonSerializable()
class FirestoreFormQuestion {
  String title;
  FormQuestionType type;
  List<String>? options;
  bool isRequired;

  // Create fromJson method.
  // ignore: sort_constructors_first
  factory FirestoreFormQuestion.fromJson(Map<String, dynamic> json) =>
      _$FirestoreFormQuestionFromJson(json);

  // ignore: sort_constructors_first
  FirestoreFormQuestion({
    required this.title,
    required this.type,
    required this.isRequired,
    this.options,
  });
  // Create toJson method.
  Map<String, dynamic> toJson() => _$FirestoreFormQuestionToJson(this);
}

enum FormQuestionType {
  singleChoice,
  text,
}
