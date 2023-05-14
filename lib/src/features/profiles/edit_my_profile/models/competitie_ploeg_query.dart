import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';

@immutable
class CompetitiePloegQuery {
  final Gender gender;
  final int year;

  const CompetitiePloegQuery({
    required this.gender,
    required this.year,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CompetitiePloegQuery &&
        other.gender == gender &&
        other.year == year;
  }

  @override
  int get hashCode => gender.hashCode ^ year.hashCode;
}
