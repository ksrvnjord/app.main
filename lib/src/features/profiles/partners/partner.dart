// ignore_for_file: sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'partner.g.dart';

@JsonSerializable()
class Partner {
  final String name;
  final String logoUrl;
  final String? websiteUrl;
  final String? description;
  final String? type;
  // ignore: unused-code, sort_constructors_first
  factory Partner.fromJson(Map<String, dynamic> json) =>
      _$PartnerFromJson(json);
  const Partner({
    required this.name,
    required this.logoUrl,
    this.websiteUrl,
    this.description,
    this.type,
  });

  // ToJson method.
  Map<String, dynamic> toJson() => _$PartnerToJson(this);
}
