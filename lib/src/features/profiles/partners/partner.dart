import 'package:json_annotation/json_annotation.dart';

part 'partner.g.dart';

@JsonSerializable()
class Partner {
  final String name;
  final String logoUrl;
  final String? websiteUrl;
  final String? description;
  final String? type;

  const Partner({
    required this.name,
    required this.logoUrl,
    this.websiteUrl,
    this.description,
    this.type,
  });

  // ignore: unused-code
  factory Partner.fromJson(Map<String, dynamic> json) =>
      _$PartnerFromJson(json);

  // ToJson method.
  Map<String, dynamic> toJson() => _$PartnerToJson(this);
}
