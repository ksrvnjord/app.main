import 'package:flutter_riverpod/flutter_riverpod.dart';

final wedstrijdPloegenProvider = Provider<List<String>>(
  (ref) {
    return [
      "Eerstejaars Dames",
      "Eerstejaars Licht",
      "Eerstejaars Zwaar",
      "Eerstejaars Lichte Dames",
      "Middengroep Dames",
      "Middengroep Licht",
      "Middengroep Zwaar",
      "Middengroep Lichte Dames",
      "Scull",
    ]..sort();
  },
);
