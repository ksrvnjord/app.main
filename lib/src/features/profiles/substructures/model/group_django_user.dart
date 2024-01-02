import 'package:json_annotation/json_annotation.dart';

part 'group_django_user.g.dart';

@JsonSerializable()
class GroupDjangoUser {
  @JsonKey(name: "first_name")
  final String firstName;
  @JsonKey(name: "last_name")
  final String lastName;
  final int identifier;
  // ignore: prefer-correct-identifier-length
  final int id;

  GroupDjangoUser({
    required this.firstName,
    required this.lastName,
    required this.identifier,
    required this.id,
  });

  factory GroupDjangoUser.fromJson(Map<String, dynamic> json) =>
      _$GroupDjangoUserFromJson(json);

  Map<String, dynamic> toJson() => _$GroupDjangoUserToJson(this);
}
