import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/firebase_user.dart';

final myPloegenProvider =
    StreamProvider.autoDispose<QuerySnapshot<PloegEntry>>((ref) async* {
  // we have to mark as async* because we need to await the future and lazily yield
  final uid = ref.watch(currentFirebaseUserProvider)!.uid;

  final userDoc = await ref.watch(firestoreUserFutureProvider(uid).future);

  yield* userDoc.reference
      .collection('groups')
      .withConverter(
        fromFirestore: (snapshot, _) => PloegEntry.fromJson(snapshot.data()!),
        toFirestore: (ploegEntry, _) => ploegEntry.toJson(),
      )
      .where('type', isEqualTo: 'ploeg')
      .snapshots();
});
