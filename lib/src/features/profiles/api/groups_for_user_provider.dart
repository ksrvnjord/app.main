import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/ploegen_for_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/group_entry.dart';

final groupsForUserProvider =
    FutureProvider.family<List<QueryDocumentSnapshot<GroupEntry>>, String>(
  (ref, userId) async {
    final commissies = ref.watch(commissiesForUserProvider(userId).future);

    final ploegen = ref.watch(ploegenForUserProvider(userId).future);

    // await for both futures to complete
    final snapshots = await Future.wait([commissies, ploegen]);

    return snapshots // [ snapshot, snapshot]
        .map(
          (querySnapshot) => querySnapshot.docs,
        ) // [ [doc, doc], [doc, doc] ]
        .expand((element) => element) // [ doc, doc, doc, doc ]
        .toList()
      ..sort((a, b) => b.data().year.compareTo(a
          .data()
          .year)); // docs is a combination of multiple queries so must be sorted
  },
);
