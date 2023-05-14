import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/competitie_ploeg.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/competitie_ploeg_query.dart';

final competitiePloegenProvider =
    FutureProvider.family<List<String>, CompetitiePloegQuery>(
  (ref, query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('group_info')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              CompetitiePloeg.fromFirestore(snapshot.data()!),
          toFirestore: (ploeg, _) => ploeg.toFirestore(),
        )
        .where('year', isEqualTo: query.year)
        .where('geslacht', isEqualTo: query.gender.name)
        .orderBy('name')
        .get();

    return snapshot.docs.map((e) => e.data().name).toList();
  },
);
