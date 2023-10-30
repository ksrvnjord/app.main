import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_type_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/competitie_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/wedstrijd_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:tuple/tuple.dart';

// Provides a list with names of the ploegen, given the filters.
// Must be a future provider because the competitieploegen are fetched from the database.
// ignore: prefer-static-class
final ploegenProvider =
    StreamProvider.autoDispose.family<List<String>, int>((ref, year) async* {
  if (ref.watch(firebaseAuthUserProvider).value == null) {
    yield const [];

    return;
  }

  final selectedType = ref.watch(ploegTypeProvider);

  switch (selectedType) {
    case PloegType.wedstrijd:
      yield ref.watch(wedstrijdPloegenProvider);
      break;
    case PloegType.competitie:
      final selectedGender = ref.watch(ploegGeslachtFilterProvider);
      yield await ref.watch(
        competitiePloegenProvider(Tuple2<int, Gender>(year, selectedGender))
            .future,
      );
      break;
    default:
      throw UnimplementedError('Unknown ploeg type');
  }
});
