import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
part 'firestore_form_question.g.dart';

@JsonSerializable()
class FirestoreFormQuestion {
  FirestoreFormQuestion({
    required this.title,
    required this.type,
    required this.isRequired,
    this.id, // TODO questionUpdate: dit moet required zijn
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
  int? id;

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
  multipleChoice,
  image,
  date,
  numeric,
  unsupported, // Add an error type for unknown values
}

extension FormQuestionTypeLabel on FormQuestionType {
  String get label {
    switch (this) {
      case FormQuestionType.text:
        return 'Tekstveld';
      case FormQuestionType.singleChoice:
        return 'Enkele keuze';
      case FormQuestionType.multipleChoice:
        return 'Selectievakjes';
      case FormQuestionType.image:
        return 'Afbeelding';
      case FormQuestionType.date:
        return 'Datum';
      case FormQuestionType.numeric:
        return 'Numeriek';
      case FormQuestionType.unsupported:
        return 'Onbekend type';
    }
  }
}

extension FormQuestionTypeIcon on FormQuestionType {
  IconData get icon {
    switch (this) {
      case FormQuestionType.text:
        return Icons.text_fields;
      case FormQuestionType.singleChoice:
        return Icons.radio_button_checked;
      case FormQuestionType.multipleChoice:
        return Icons.check_box;
      case FormQuestionType.image:
        return Icons.image;
      case FormQuestionType.date:
        return Icons.calendar_month;
      case FormQuestionType.numeric:
        return Icons.numbers;
      case FormQuestionType.unsupported:
        return Icons.help_outline;
    }
  }
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
      case 'multipleChoice':
        return FormQuestionType.multipleChoice;
      case 'image':
        return FormQuestionType.image;
      case 'date':
        return FormQuestionType.date;
      case 'numeric':
        return FormQuestionType.numeric;
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
