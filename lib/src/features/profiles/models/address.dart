import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
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
  // ignore: sort_constructors_first
  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  // ignore: sort_constructors_first
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
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
