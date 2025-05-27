import 'package:json_annotation/json_annotation.dart';

part 'firestore_form_question.g.dart';

@JsonSerializable()
class FirestoreFormQuestion {
  FirestoreFormQuestion({
    required this.title,
    required this.type,
    required this.isRequired,
    this.index,
    this.options,
    this.startDate,
    this.endDate,
  });
  String title;
  @FormQuestionTypeConverter()
  FormQuestionType type;
  List<String>? options;
  bool isRequired;
  DateTime? startDate;
  DateTime? endDate;
  int? index;

  // Create fromJson method.
  // ignore: sort_constructors_first
  factory FirestoreFormQuestion.fromJson(Map<String, dynamic> json) =>
      _$FirestoreFormQuestionFromJson(json);
  // Create toJson method.
  Map<String, dynamic> toJson() => _$FirestoreFormQuestionToJson(this);
}

enum FormQuestionType {
  text,
  singleChoice,
  image,
  date,
  unsupported, // Add an error type for unknown values
}

class FormQuestionTypeConverter
    implements JsonConverter<FormQuestionType, String> {
  const FormQuestionTypeConverter();

  @override
  FormQuestionType fromJson(String json) {
    switch (json) {
      case 'text':
        return FormQuestionType.text;
      case 'singleChoice':
        return FormQuestionType.singleChoice;
      case 'image':
        return FormQuestionType.image;
      case 'date':
        return FormQuestionType.date;
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
