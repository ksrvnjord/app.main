import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';

final ploegenForUserProvider = FutureProvider.family
    .autoDispose<QuerySnapshot<PloegEntry>, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection("people")
      .doc(userId)
      .collection("groups")
      .withConverter<PloegEntry>(
        fromFirestore: (snapshot, _) =>
            PloegEntry.fromJson(snapshot.data() ?? {}),
        toFirestore: (ploeg, _) => ploeg.toJson(),
      )
      .where('type', isEqualTo: 'ploeg')
      .orderBy('year', descending: true)
      .get();
});
