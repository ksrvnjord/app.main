// Write a FutureProvider that gets the reservation filters from shared preferences.
// And returns them as a List<String>.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final reservationTypeFiltersFromSharedPrefsProvider =
    FutureProvider<List<String>>((ref) async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getStringList('afschrijf_filters') ?? [];
});
