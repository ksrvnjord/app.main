import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Gender {
  dames("Dames"),
  heren("Heren");

  const Gender(this.value);
  final String value;
}

final ploegGeslachtFilterProvider =
    StateProvider<Gender>((ref) => Gender.values.first);
