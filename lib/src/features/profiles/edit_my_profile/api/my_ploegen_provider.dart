import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user_notifier.dart';

// ignore: prefer-static-class
final myPloegenProvider =
    StreamProvider.autoDispose<QuerySnapshot<PloegEntry>>((ref) async* {
  if (ref.watch(firebaseAuthUserProvider).value == null) {
    return;
  }

  // We have to mark as async* because we need to await the future and lazily yield.
  final uid = ref.watch(currentFirestoreUserProvider)?.identifier;

  final userDoc =
      await ref.watch(firestoreUserStreamProvider(uid ?? "").future);

  yield* userDoc.docs.first.reference
      .collection('groups')
      .withConverter(
        fromFirestore: (snapshot, _) =>
            PloegEntry.fromJson(snapshot.data() ?? {}),
        toFirestore: (ploegEntry, _) => ploegEntry.toJson(),
      )
      .where('type', isEqualTo: 'ploeg')
      .orderBy('year', descending: true)
      .snapshots();
});
