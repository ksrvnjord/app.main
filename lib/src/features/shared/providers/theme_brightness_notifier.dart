import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: prefer-static-class
final themeBrightnessProvider =
    NotifierProvider<ThemeBrightnessNotifier, ThemeMode>(() {
  return ThemeBrightnessNotifier();
});

// ignore: prefer-static-class
final themeBrightnessFromSharedPrefs = FutureProvider<ThemeMode>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final themeMode = prefs.getString('themeMode');

  return ThemeMode.values.byName(themeMode ?? 'system');
});

class ThemeBrightnessNotifier extends Notifier<ThemeMode> {
  @override
  build() {
    return ThemeMode.dark;
  }

  void setThemeMode(final ThemeMode? themeMode) async {
    final theme = themeMode ?? ThemeMode.system;

    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString('themeMode', theme.name);
    if (!result) {
      throw Exception('Could not save themeMode to SharedPreferences');
    }
    state = theme;
  }
}
