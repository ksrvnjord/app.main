import 'package:json_annotation/json_annotation.dart';

/// Simple model class to hold the question and answer of a form.
///
///

part 'form_question_answer.g.dart';

@JsonSerializable()
class FormQuestionAnswer {
  final String?
      questionTitle; // TODO questionUpdate: dit is depcrecated, gebruik enkel nog questionId
  final int?
      questionId; //TODO questionUpdate: make this required and remove nullable
  String? answer;

  // ignore: sort_constructors_first
  FormQuestionAnswer(
      {this.questionTitle, this.questionId, required this.answer});

  // Create fromJson method.
  // ignore: sort_constructors_first
  factory FormQuestionAnswer.fromJson(Map<String, dynamic> json) =>
      _$FormQuestionAnswerFromJson(json);

  // Create toJson method.
  Map<String, dynamic> toJson() => _$FormQuestionAnswerToJson(this);
}
