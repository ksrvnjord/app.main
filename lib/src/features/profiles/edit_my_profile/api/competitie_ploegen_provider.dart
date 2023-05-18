import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_year_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/competitie_ploeg.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';

final competitiePloegenProvider = FutureProvider<List<String>>(
  (ref) async {
    final int selectedYear = ref.watch(ploegYearProvider);
    final selectedGender = ref.watch(ploegGeslachtFilterProvider).name;

    final snapshot = await FirebaseFirestore.instance
        .collection('group_info')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              CompetitiePloeg.fromFirestore(snapshot.data()!),
          toFirestore: (ploeg, _) => ploeg.toFirestore(),
        )
        .where('year', isEqualTo: selectedYear)
        .where(
          'geslacht',
          isEqualTo: selectedGender,
        )
        .orderBy('name')
        .get();

    return snapshot.docs.map((e) => e.data().name).toList();
  },
);
