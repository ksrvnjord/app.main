class FirestoreFormQuestion {
  String label;
  FormQuestionType type;
  List<String>? options;
  bool isRequired;

  FirestoreFormQuestion({
    required this.label,
    required this.type,
    this.options,
    this.isRequired = true,
  });

  // Create fromJson method.
  factory FirestoreFormQuestion.fromJson(Map<String, dynamic> json) {
    return FirestoreFormQuestion(
      label: json['Label'],
      type: FormQuestionType.values.byName(json['Type']),
      options:
          json['Choices'] == null ? null : List<String>.from(json['Choices']),
      isRequired: json['IsRequired'] ?? true, // TODO: Remove this.
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {'Choices': options, 'Label': label, 'Type': type.name, 'IsRequired': isRequired};
  }
}

enum FormQuestionType {
  singleChoice,
  text,
}
