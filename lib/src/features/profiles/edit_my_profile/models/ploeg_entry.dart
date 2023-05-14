import 'dart:collection';

import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/group_entry.dart';

class PloegEntry extends GroupEntry {
  final PloegType ploegType;

  static Map<String, PloegType> get typeMap => {
        'competitie': PloegType.competitie,
        'wedstrijd': PloegType.wedstrijd,
      };

  // reverse of typemap
  static Map<PloegType, String> get typeMapReverse => LinkedHashMap.fromEntries(
        typeMap.entries.map((entry) => MapEntry(entry.value, entry.key)),
      );

  PloegEntry({
    required int year,
    required String name,
    required String firstName,
    required String lastName,
    required String identifier,
    required this.ploegType,
  }) : super(
          year: year,
          name: name,
          firstName: firstName,
          lastName: lastName,
          identifier: identifier,
        );

  factory PloegEntry.fromJson(Map<String, dynamic> json) {
    return PloegEntry(
      year: json['year'],
      name: json['name'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      identifier: json['identifier'],
      ploegType: typeMap[json['ploegType']]!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'identifier': identifier,
      'ploegType': typeMapReverse[ploegType],
    };
  }
}

enum PloegType {
  competitie("Competitie"),
  wedstrijd("Wedstrijd");

  const PloegType(this.name);

  final String name;
}
