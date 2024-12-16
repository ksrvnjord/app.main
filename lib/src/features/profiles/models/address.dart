import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  Address({
    this.street,
    this.houseNumber,
    this.houseNumberAddition,
    this.addressTwo,
    this.postalCode,
    this.city,
    this.country,
    this.visible,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  String? street;

  @JsonKey(name: 'housenumber')
  String? houseNumber;
  @JsonKey(name: 'housenumber_addition')
  String? houseNumberAddition;

  @JsonKey(name: 'address_two')
  String? addressTwo;
  @JsonKey(name: 'zipcode')
  String? postalCode;

  String? city;
  final String? country;

  bool? visible;

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
