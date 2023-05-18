import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_type_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/competitie_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/wedstrijd_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';

final ploegenProvider = Provider<List<String>>((ref) {
  final selectedType = ref.watch(ploegTypeProvider);

  switch (selectedType) {
    case PloegType.wedstrijd:
      return ref.watch(wedstrijdPloegenProvider);
    case PloegType.competitie:
      final ploegen = ref.watch(competitiePloegenProvider);

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
