/// Simple model class to hold the question and answer of a form.
class FormQuestionAnswer {
  final String question;
  String? answer;

  FormQuestionAnswer({required this.question, required this.answer});

  // Create fromJson method.
  factory FormQuestionAnswer.fromJson(Map<String, dynamic> json) {
    return FormQuestionAnswer(
      question: json['name'],
      answer: json['answer'],
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {
      'name': question,
      'answer': answer,
    };
  }
}
