import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';

// ignore: prefer-static-class
final homeUsers = StreamProvider.autoDispose
    .family<QuerySnapshot<FirestoreAlmanakProfile>, String>(
  (ref, houseName) => ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : FirebaseFirestore.instance
          .collection("people")
          .withConverter(
            fromFirestore: (snapshot, _) =>
                FirestoreAlmanakProfile.fromFirestore(snapshot.data() ?? {}),
            toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
          )
          .where("huis", isEqualTo: houseName)
          .snapshots(),
);
