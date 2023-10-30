import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/ploegen_for_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_commissies.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/group_entry.dart';

// ignore: prefer-static-class
final groupsForUserProvider = StreamProvider.autoDispose
    .family<List<QueryDocumentSnapshot<GroupEntry>>, String>(
  (ref, userId) async* {
    if (ref.watch(firebaseAuthUserProvider).value == null) {
      yield const [];

      return;
    }

    final commissies = ref.watch(commissiesForUserProvider(userId).future);

    final ploegen = ref.watch(ploegenForUserProvider(userId).future);

    // Await for both futures to complete.
    final snapshots = await Future.wait([commissies, ploegen]);

    yield snapshots // [ snapshot, snapshot].
        .map(
          (querySnapshot) => querySnapshot.docs,
        ) // [ [doc, doc], [doc, doc] ].
        .expand((element) => element) // [ doc, doc, doc, doc ].
        .toList()
      ..sort((a, b) => b.data().year.compareTo(a
          .data()
          .year)); // Docs is a combination of multiple queries so must be sorted.
  },
);
