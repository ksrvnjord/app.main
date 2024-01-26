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

  // copyWith method.
  FirestoreFormQuestion copyWith({
    String? label,
    FormQuestionType? type,
    List<String>? options,
    bool? isRequired,
  }) {
    return FirestoreFormQuestion(
      title: label ?? title,
      type: type ?? this.type,
      options: options ?? this.options,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}

enum FormQuestionType {
  singleChoice,
  text,
}
