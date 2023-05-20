import 'package:flutter/foundation.dart';

@immutable
class Address {
  final String? street;
  final String? houseNumber;
  final String? houseNumberAddition;
  final String? postalCode;
  final String? city;

  const Address({
    this.street,
    this.houseNumber,
    this.houseNumberAddition,
    this.postalCode,
    this.city,
  });

  // Add a factory constructor that takes a Map<String, dynamic> and returns an Address.
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String?,
      houseNumber: json['houseNumber'] as String?,
      houseNumberAddition: json['houseNumberAddition'] as String?,
      postalCode: json['postalCode'] as String?,
      city: json['city'] as String?,
    );
  }

  // Add a toJson method that returns a Map<String, dynamic>.
  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'houseNumber': houseNumber,
      'houseNumberAddition': houseNumberAddition,
      'postalCode': postalCode,
      'city': city,
    };
  }
}
