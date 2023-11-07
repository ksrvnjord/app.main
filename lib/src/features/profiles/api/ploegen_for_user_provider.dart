import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';

// ignore: prefer-static-class
final ploegenForUserProvider =
    StreamProvider.family<QuerySnapshot<PloegEntry>, String>((ref, userId) {
  return ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : FirebaseFirestore.instance
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
          .snapshots();
});
