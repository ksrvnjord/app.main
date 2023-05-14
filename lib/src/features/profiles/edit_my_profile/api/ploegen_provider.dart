import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/api/wedstrijd_ploegen_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry_create_notifier.dart';

final ploegenProvider = Provider<List<String>>((ref) {
  final type = ref.watch(ploegEntryCreateNotifierProvider).ploegType;
  switch (type) {
    case PloegType.wedstrijd:
      return ref.watch(wedstrijdPloegenProvider);
    case PloegType.competitie:
      return []; // TODO: implement competitie ploegen
    default:
      throw UnimplementedError('Unknown ploeg type');
  }
});
