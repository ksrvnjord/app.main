// ignore_for_file: unused-code

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'huis_info.freezed.dart';
part 'huis_info.g.dart';

@freezed
class HuisInfo with _$HuisInfo {
  // ignore: sort_constructors_first
  factory HuisInfo({
    required String name,
    required String description,
    required bool allNjord,
    required HouseComposition composition,
    required String houseNumber,
    required String streetName,
    required String postalCode,
    required int numberOfHousemates,
    required int yearOfFoundation,
  }) = _HuisInfo;

  factory HuisInfo.fromJson(Map<String, dynamic> json) =>
      _$HuisInfoFromJson(json);
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
