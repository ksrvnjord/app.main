// ignore_for_file: sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'info.g.dart';

@JsonSerializable()
class Info {
  final int blikken;
  final int taarten;
  bool dubbellid;
  String? studie;
  @JsonKey(name: 'educational_institute')
  final String? educationalInstitute;
  final bool magazine;
  @JsonKey(name: 'other_clubs')
  final List<String> otherClubs;
  @JsonKey(name: 'other_rowing_clubs')
  final List<String> otherRowingClubs;
  final bool honorary;
  Info({
    required this.blikken,
    required this.taarten,
    required this.dubbellid,
    this.studie,
    this.educationalInstitute,
    required this.magazine,
    required this.otherClubs,
    required this.otherRowingClubs,
    required this.honorary,
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}
