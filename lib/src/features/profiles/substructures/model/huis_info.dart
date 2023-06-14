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

  const HuisInfo({
    required String name,
    String? description,
    required this.allNjord,
    required this.composition,
    required this.houseNumber,
    required this.streetName,
    required this.postalCode,
    required this.numberOfHousemates,
    required this.yearOfFoundation,
  }) : super(name: name, description: description);

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
  factory HuisInfo.fromJson(String source) =>
      HuisInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  HuisInfo copyWith({
    bool? allNjord,
    HouseComposition? composition,
    String? houseNumber,
    String? streetName,
    String? postalCode,
    int? numberOfHousemates,
    int? yearOfFoundation,
    String? name,
    String? description,
  }) {
    return HuisInfo(
      name: name ?? this.name,
      description: description ?? this.description,
      allNjord: allNjord ?? this.allNjord,
      composition: composition ?? this.composition,
      houseNumber: houseNumber ?? this.houseNumber,
      streetName: streetName ?? this.streetName,
      postalCode: postalCode ?? this.postalCode,
      numberOfHousemates: numberOfHousemates ?? this.numberOfHousemates,
      yearOfFoundation: yearOfFoundation ?? this.yearOfFoundation,
    );
  }

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
  male("Man"),
  female("Vrouw"),
  mixed("Man/Vrouw");

  final String value;

  const HouseComposition(this.value);
}
