class FirestoreFormQuestion {
  final String label;
  final String type;
  final List<String>? options;

  FirestoreFormQuestion({
    required this.label,
    required this.type,
    this.options,
  });

  // Create fromJson method.
  factory FirestoreFormQuestion.fromJson(Map<String, dynamic> json) {
    return FirestoreFormQuestion(
      label: json['Label'],
      type: json['Type'],
      options:
          json['Choices'] != null ? List<String>.from(json['Choices']) : null,
    );
  }

  // Create toJson method.
  Map<String, dynamic> toJson() {
    return {
      'Label': label,
      'Type': type,
      'Choices': options,
    };
  }
}
