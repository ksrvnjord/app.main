class FirestoreFormQuestion {
  String label;
  FormQuestionType type;
  List<String>? options;

  FirestoreFormQuestion({
    required this.label,
    required this.type,
    this.options,
  });

  // Create fromJson method.
  factory FirestoreFormQuestion.fromJson(Map<String, dynamic> json) {
    return FirestoreFormQuestion(
      label: json['Label'],
      type: FormQuestionType.values.byName(json['Type']),
      options:
          json['Choices'] == null ? null : List<String>.from(json['Choices']),
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {'Choices': options, 'Label': label, 'Type': type.name};
  }
}

enum FormQuestionType {
  singleChoice,
  text,
}
