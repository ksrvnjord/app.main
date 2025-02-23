import 'package:json_annotation/json_annotation.dart';

part 'firestore_form_question.g.dart';

@JsonSerializable()
class FirestoreFormQuestion {
  String title;
  @FormQuestionTypeConverter()
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
  image,
  unsupported, // Add an error type for unknown values
}

class FormQuestionTypeConverter
    implements JsonConverter<FormQuestionType, String> {
  const FormQuestionTypeConverter();

  @override
  FormQuestionType fromJson(String json) {
    switch (json) {
      case 'singleChoice':
        return FormQuestionType.singleChoice;
      case 'text':
        return FormQuestionType.text;
      case 'image':
        return FormQuestionType.image;
      default:
        // Handle undefined FormQuestionType
        return FormQuestionType.unsupported; // Default value for unknown types
    }
  }

  @override
  String toJson(FormQuestionType object) {
    return object.toString().split('.').last;
  }
}
