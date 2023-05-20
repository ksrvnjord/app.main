import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/choice/providers/ploeg_year_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';

final ploegUsersProvider =
    FutureProvider.family<QuerySnapshot<PloegEntry>, String>(
  (ref, name) {
    final selectedYear =
        ref.watch(ploegYearProvider); // Year can be changed in state.

    return FirebaseFirestore.instance
        .collectionGroup('groups')
        .withConverter(
          fromFirestore: (snapshot, _) => PloegEntry.fromJson(snapshot.data()!),
          toFirestore: (entry, _) => entry.toJson(),
        )
        .where('name', isEqualTo: name)
        .where('year', isEqualTo: selectedYear)
        .get();
  },
);
