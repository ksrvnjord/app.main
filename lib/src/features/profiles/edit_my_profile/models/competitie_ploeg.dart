import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';

class CompetitiePloeg {
  final String name;
  final Gender gender;
  final String verticale;
  final int year;

  const CompetitiePloeg({
    required this.name,
    required this.gender,
    required this.verticale,
    required this.year,
  });

  factory CompetitiePloeg.fromFirestore(Map<String, dynamic> json) {
    return CompetitiePloeg(
      name: json['name'],
      gender: Gender.values.byName(json['geslacht']),
      verticale: json['verticale'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'gender': gender.name,
      'verticale': verticale,
      'year': year,
    };
  }
}
