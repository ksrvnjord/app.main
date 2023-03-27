import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/shared_preferences_reservationfilters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/calendar/filters/model/boat_types.dart';

class ReservationObjectTypeFiltersNotifier
    extends StateNotifier<Map<String, List<String>>> {
  ReservationObjectTypeFiltersNotifier(Map<String, List<String>> filters)
      : super(filters);

  void updateFilters(Map<String, List<String>> filters) {
    state = filters;
    _saveToSharedPrefs();
  }

  void updateFiltersForCategory(String category, List<String> filters) {
    state = {...state, category: filters};
    _saveToSharedPrefs();
  }

  // has no filters
  bool get isEmpty {
    for (final entry in state.entries) {
      if (entry.value.isNotEmpty) return false;
    }

    return true;
  }

  // create private method that saves state to shared preferences
  void _saveToSharedPrefs() async {
    List<String> allFilters = [];
    for (final entry in state.entries) {
      allFilters.addAll(entry.value);
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('afschrijf_filters', allFilters);
  }
}

final reservationTypeFiltersProvider = StateNotifierProvider.autoDispose<
    ReservationObjectTypeFiltersNotifier, Map<String, List<String>>>(
  (ref) {
    final filterList = ref.watch(reservationTypeFiltersFromSharedPrefsProvider);

    return ReservationObjectTypeFiltersNotifier(filterList.when(
      data: (data) {
        Map<String, List<String>> filters = {};
        for (final entry in reservationObjectTypes.entries) {
          String category = entry.key;
          List<String> types = entry.value;

          if (!filters.containsKey(category)) filters[category] = [];

          for (final filter in data) {
            if (types.contains(filter)) {
              filters[category]?.add(filter);
            }
          }
        }

        return filters;
      },
      loading: () => {},
      error: (error, stackTrace) => {},
    ));
  },
);
