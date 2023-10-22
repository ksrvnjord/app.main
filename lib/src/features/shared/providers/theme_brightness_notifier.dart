import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: prefer-static-class
final themeBrightnessProvider =
    AsyncNotifierProvider<ThemeBrightnessNotifier, ThemeMode>(() {
  return ThemeBrightnessNotifier();
});

class ThemeBrightnessNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString('themeMode');

    return ThemeMode.values.byName(themeMode ?? 'dark');
  }

  Future<void> setThemeMode(final ThemeMode? themeMode) async {
    final theme = themeMode ?? ThemeMode.system;

    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString('themeMode', theme.name);
    if (!result) {
      throw Exception('Could not save themeMode to SharedPreferences');
    }
    state = AsyncValue.data(theme);
  }
}
