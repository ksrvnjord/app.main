import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_type_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_year_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/competitie_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/wedstrijd_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:tuple/tuple.dart';

// Provides a list with names of the ploegen, given the filters.
// Must be a future provider because the competitieploegen are fetched from the database.
// ignore: prefer-static-class
final ploegenProvider = FutureProvider<List<String>>((ref) async {
  final selectedType = ref.watch(ploegTypeProvider);

  switch (selectedType) {
    case PloegType.wedstrijd:
      return ref.watch(wedstrijdPloegenProvider);
    case PloegType.competitie:
      final year = ref.watch(ploegYearProvider);
      final selectedGender = ref.watch(ploegGeslachtFilterProvider);
      return ref.watch(
        competitiePloegenProvider(Tuple2<int, Gender>(year, selectedGender))
            .future,
      );
    default:
      throw UnimplementedError('Unknown ploeg type');
  }
});
