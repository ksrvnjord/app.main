import 'package:json_annotation/json_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'firestore_form_filler.g.dart';

@JsonSerializable()
class FirestoreFormFiller {
  FirestoreFormFiller({
    required this.index,
    required this.title,
    required this.body,
    required this.hasImage,
    this.image,
  });
  int index;
  String title;
  String body;
  bool hasImage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  XFile? image;

  // Create fromJson method.
  // ignore: sort_constructors_first
  factory FirestoreFormFiller.fromJson(Map<String, dynamic> json) =>
      _$FirestoreFormFillerFromJson(json);
  // Create toJson method.
  Map<String, dynamic> toJson() => _$FirestoreFormFillerToJson(this);
}
