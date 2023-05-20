import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
final postTopicsProvider = Provider<List<String>>((ref) {
  // Return the 'name' field of each document.
  return [
    'Promotie',
    'Wandelgangen',
    'Coach gezocht',
    'Gevonden voorwerpen',
    'Kaartjes',
  ];
});
