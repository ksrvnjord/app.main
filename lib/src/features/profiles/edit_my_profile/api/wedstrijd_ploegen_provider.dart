import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
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
      "Oude Vier",
      "Dames Vier",
      "Scull",
    ]..sort();
  },
);
