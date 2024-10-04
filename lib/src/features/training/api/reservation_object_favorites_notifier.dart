import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationObjectFavoritesNotifier extends StateNotifier<Set<String>> {
  ReservationObjectFavoritesNotifier(super.filters);

  void toggleObjectFavorite(String object) {
    if (state.contains(object)) {
      _removeObjectFromFavorites(object);
    } else {
      _addObjectToFavorites(object);
    }
  }

  void _addObjectToFavorites(String object) {
    state = {...state, object};
    _saveToSharedPrefs();
  }

  void _removeObjectFromFavorites(String object) {
    state = state.where((element) => element != object).toSet();
    _saveToSharedPrefs();
  }

  // Create private method that saves state to shared preferences.
  void _saveToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: avoid-ignoring-return-values
    await prefs.setStringList('reservation_favorites', state.toList());
  }
}

// ignore: prefer-static-class
final favoriteObjectsProvider =
    StateNotifierProvider<ReservationObjectFavoritesNotifier, Set<String>>(
  (ref) {
    final favoritesVal = ref.watch(favoritesFromSharedPrefsProvider);

    return ReservationObjectFavoritesNotifier(favoritesVal.when(
      data: (favorites) => favorites.toSet(),
      error: (error, stackTrace) {
        // ignore: avoid-async-call-in-sync-function
        FirebaseCrashlytics.instance.recordError(error, stackTrace);

        return {};
      },
      loading: () => {},
    ));
  },
);

// ignore: prefer-static-class
final favoritesFromSharedPrefsProvider =
    FutureProvider<Set<String>>((ref) async {
  final prefs = await SharedPreferences
      .getInstance(); // TODO: init shared prefs in main.dart, so we can use Shared Preference synchronously.

  return prefs.getStringList('reservation_favorites')?.toSet() ?? {};
});

// ignore: prefer-static-class
final showFavoritesProvider = StateProvider<bool>((ref) => false);
