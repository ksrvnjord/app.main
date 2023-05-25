import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

// ignore: prefer-static-class
final firestoreUserFutureProvider = FutureProvider.family<
    QueryDocumentSnapshot<FirestoreAlmanakProfile>, String>(
  (ref, userId) async {
    QuerySnapshot<FirestoreAlmanakProfile> profile =
        await FirebaseFirestore.instance
            .collection('people')
            .withConverter<FirestoreAlmanakProfile>(
              fromFirestore: (snapshot, _) =>
                  FirestoreAlmanakProfile.fromFirestore(snapshot.data() ?? {}),
              toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
            )
            .where('identifier', isEqualTo: userId)
            .limit(1)
            .get();

    return profile.docs.first;
  },
);

// ignore: prefer-static-class
final currentfirestoreUserFutureProvider =
    FutureProvider<QueryDocumentSnapshot<FirestoreAlmanakProfile>>(
  (ref) async {
    final user = ref.watch(firebaseAuthUserProvider);
    QuerySnapshot<FirestoreAlmanakProfile> profile =
        await FirebaseFirestore.instance
            .collection('people')
            .withConverter<FirestoreAlmanakProfile>(
              fromFirestore: (snapshot, _) =>
                  FirestoreAlmanakProfile.fromFirestore(snapshot.data() ?? {}),
              toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
            )
            .where('identifier', isEqualTo: user?.uid)
            .limit(1)
            .get();

    return profile.docs.first;
  },
);
