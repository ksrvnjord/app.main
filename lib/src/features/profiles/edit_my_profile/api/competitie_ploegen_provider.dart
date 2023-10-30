import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/competitie_ploeg.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/gender.dart';
import 'package:tuple/tuple.dart';

// We give year and gender to this provider, so we can save the state for a selected filter combination.
// ignore: prefer-static-class
final competitiePloegenProvider =
    StreamProvider.autoDispose.family<List<String>, Tuple2<int, Gender>>(
  (ref, yearAndGender) async* {
    if (ref.watch(firebaseAuthUserProvider).value == null) {
      yield const [];

      return;
    }

    final int selectedYear = yearAndGender.item1;
    final selectedGender = yearAndGender.item2;

    final snapshot = await FirebaseFirestore.instance
        .collection('group_info')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              CompetitiePloeg.fromFirestore(snapshot.data() ?? {}),
          toFirestore: (ploeg, _) => ploeg.toFirestore(),
        )
        .where('year', isEqualTo: selectedYear)
        .where(
          'geslacht',
          isEqualTo: selectedGender.name,
        )
        .orderBy('name')
        .get();

    yield snapshot.docs.map((e) => e.data().name).toList();
  },
);
