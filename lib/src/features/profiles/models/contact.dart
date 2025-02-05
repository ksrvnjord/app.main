import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  String email;
  @JsonKey(name: 'email_visible')
  bool emailVisible;
  @JsonKey(name: 'phone_primary')
  String phonePrimary;
  @JsonKey(name: 'phone_secondary')
  String? phoneSecondary;
  @JsonKey(name: 'phone_visible')
  bool phoneVisible;
  // ignore: sort_constructors_first
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  // ignore: sort_constructors_first
  Contact({
    required this.email,
    required this.emailVisible,
    required this.phonePrimary,
    this.phoneSecondary,
    required this.phoneVisible,
  });

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
