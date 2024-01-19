/// Simple model class to hold the question and answer of a form.
class FormQuestionAnswer {
  final String question;
  String? answer;
  bool isRequiredAndCompleted;

  FormQuestionAnswer({
    required this.question,
    required this.answer,
    this.isRequiredAndCompleted = false,
  });

  // Create fromJson method.
  factory FormQuestionAnswer.fromJson(Map<String, dynamic> json) {
    return FormQuestionAnswer(
      question: json['name'],
      answer: json['answer'],
      isRequiredAndCompleted: json['completed'],
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {'answer': answer, 'name': question, 'completed': isRequiredAndCompleted};
  }
}
