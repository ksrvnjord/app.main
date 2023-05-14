import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/competitie_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/wedstrijd_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/competitie_ploeg_query.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry_create_notifier.dart';

final ploegenProvider = Provider<List<String>>((ref) {
  final form = ref.watch(ploegEntryCreateNotifierProvider);
  final selectedType = form.ploegType;
  switch (selectedType) {
    case PloegType.wedstrijd:
      return ref.watch(wedstrijdPloegenProvider);
    case PloegType.competitie:
      final Gender selectedGender = ref.watch(
        ploegGeslachtFilterProvider,
      ); // is not part of the submission to Firestore
      final int selectedYear = form.year;

      final ploegen = ref.watch(competitiePloegenProvider(
        CompetitiePloegQuery(gender: selectedGender, year: selectedYear),
      ));

      return ploegen.when(
        data: (data) => data,
        loading: () => [],
        error: (err, __) {
          throw err;
        },
      );
    default:
      throw UnimplementedError('Unknown ploeg type');
  }
});
