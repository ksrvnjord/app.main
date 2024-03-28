import 'package:json_annotation/json_annotation.dart';

part 'partner.g.dart';

@JsonSerializable()
class Partner {
  final String name;
  final String logoUrl;
  final String websiteUrl;
  final String description;
  final String type;

  const Partner({
    required this.name,
    required this.logoUrl,
    required this.websiteUrl,
    required this.description,
    required this.type,
  });

  // ignore: unused-code
  factory Partner.fromJson(Map<String, dynamic> json) =>
      _$PartnerFromJson(json);
}
