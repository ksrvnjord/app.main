import 'package:json_annotation/json_annotation.dart';

/// Simple model class to hold the question and answer of a form.
///
///

part 'form_question_answer.g.dart';

@JsonSerializable()
class FormQuestionAnswer {
  final String questionTitle;
  String? answer;

  FormQuestionAnswer({
    required this.questionTitle,
    required this.answer,
  });

  // Create fromJson method.
  factory FormQuestionAnswer.fromJson(Map<String, dynamic> json) =>
      _$FormQuestionAnswerFromJson(json);

  // Create toJson method.
  Map<String, dynamic> toJson() => _$FormQuestionAnswerToJson(this);
}
