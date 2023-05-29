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
  build() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('themeMode');
    try {
      return ThemeMode.values.byName(themeStr ?? 'system');
    } catch (e) {
      return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode? themeMode) async {
    themeMode ??= ThemeMode.system;

    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString('themeMode', themeMode.name);
    if (!result) {
      throw Exception('Could not save themeMode to SharedPreferences');
    }
    state = AsyncValue.data(themeMode);
  }
}
