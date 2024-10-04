import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@immutable
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
  Contact({
    required this.email,
    required this.emailVisible,
    required this.phonePrimary,
    this.phoneSecondary,
    required this.phoneVisible,
  });

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
