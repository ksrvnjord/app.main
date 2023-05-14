import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/competitie_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/wedstrijd_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/competitie_ploeg_query.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry_create_notifier.dart';

final ploegenProvider = Provider<List<String>>((ref) {
  final selectedType = ref.watch(ploegEntryCreateNotifierProvider).ploegType;
  switch (selectedType) {
    case PloegType.wedstrijd:
      return ref.watch(wedstrijdPloegenProvider);
    case PloegType.competitie:
      final Gender selectedGender = ref.watch(ploegGeslachtFilterProvider);

      final ploegen = ref.watch(competitiePloegenProvider(
        CompetitiePloegQuery(gender: selectedGender, year: 2022),
      ));

      return ploegen.when(
        data: (data) => data,
        loading: () => [],
        error: (err, __) {
          return [];
        },
      );
    default:
      throw UnimplementedError('Unknown ploeg type');
  }
});
