import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';

// ignore: prefer-static-class
final bestuurUsersProvider =
    StreamProvider.autoDispose<QuerySnapshot<FirestoreAlmanakProfile>>(
  (ref) => ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : FirebaseFirestore.instance
          .collection("people")
          .withConverter(
            fromFirestore: (snapshot, _) =>
                FirestoreAlmanakProfile.fromFirestore(snapshot.data() ?? {}),
            toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
          )
          .where("bestuurs_functie", isNull: false)
          .snapshots(),
);
