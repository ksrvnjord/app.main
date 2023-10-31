import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';

//ignore: prefer-static-class
final peopleCollection = FirebaseFirestore.instance
    .collection('people')
    .withConverter<FirestoreAlmanakProfile>(
      fromFirestore: (snapshot, _) =>
          FirestoreAlmanakProfile.fromJson(snapshot.data() ?? {}),
      toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
    );

// ignore: prefer-static-class
final firestoreUserStreamProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<FirestoreAlmanakProfile>, String>(
  (ref, userId) {
    return ref.watch(firebaseAuthUserProvider).value == null
        ? const Stream.empty()
        : peopleCollection
            .where('identifier', isEqualTo: userId)
            .limit(1)
            .snapshots();
  },
);

// ignore: prefer-static-class
final currentfirestoreUserStreamProvider =
    StreamProvider<QuerySnapshot<FirestoreAlmanakProfile>>(
  (ref) {
    final user = ref.watch(firebaseAuthUserProvider).value;

    return user == null
        ? const Stream.empty()
        : peopleCollection
            .where('identifier', isEqualTo: user.uid)
            .limit(1)
            .snapshots();
  },
);
