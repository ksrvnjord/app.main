// ignore_for_file: unused-code

import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_info.dart';
import 'dart:convert';

@immutable
class HuisInfo extends GroupInfo {
  final bool allNjord;
  final HouseComposition composition;
  final String houseNumber;
  final String streetName;
  final String postalCode;
  final int numberOfHousemates;
  final int yearOfFoundation;

  // ignore: sort_constructors_first
  const HuisInfo({
    required super.name,
    required String super.description,
    required this.allNjord,
    required this.composition,
    required this.houseNumber,
    required this.streetName,
    required this.postalCode,
    required this.numberOfHousemates,
    required this.yearOfFoundation,
  });

  // ignore: sort_constructors_first
  factory HuisInfo.fromMap(Map<String, dynamic> map) {
    return HuisInfo(
      name: map['name'] as String,
      description: map['description'] as String,
      allNjord: map['allNjord'] as bool,
      composition: HouseComposition.values.byName(
        map['composition'] as String,
      ),
      houseNumber: map['houseNumber'] as String,
      streetName: map['streetName'] as String,
      postalCode: map['postalCode'] as String,
      numberOfHousemates: map['numberOfHousemates'] as int,
      yearOfFoundation: map['yearOfFoundation'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'HuisInfo(allNjord: $allNjord, composition: $composition, houseNumber: $houseNumber, streetName: $streetName, postalCode: $postalCode, numberOfHousemates: $numberOfHousemates, yearOfFoundation: $yearOfFoundation)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'allNjord': allNjord,
      'composition': composition.name,
      'houseNumber': houseNumber,
      'streetName': streetName,
      'postalCode': postalCode,
      'numberOfHousemates': numberOfHousemates,
      'yearOfFoundation': yearOfFoundation,
    };
  }
}

enum HouseComposition {
  // ignore: unused-code
  male("Man"),
  // ignore: unused-code
  female("Vrouw"),
  // ignore: unused-code
  mixed("Man/Vrouw");

  final String value;

  // ignore: sort_constructors_first
  const HouseComposition(this.value);
}
