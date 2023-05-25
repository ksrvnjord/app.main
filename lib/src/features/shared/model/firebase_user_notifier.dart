import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

class FirebaseUserNotifier extends StateNotifier<FirestoreAlmanakProfile?> {
  FirebaseUserNotifier(FirestoreAlmanakProfile? user) : super(user);
}

// ignore: prefer-static-class
final currentFirestoreUserProvider =
    StateNotifierProvider<FirebaseUserNotifier, FirestoreAlmanakProfile?>(
  (ref) {
    final user = ref.watch(firebaseAuthUserProvider);

    if (user == null) return FirebaseUserNotifier(null);

    final firestoreUserVal = ref.watch(currentfirestoreUserFutureProvider);

    final FirestoreAlmanakProfile? firebaseUser = firestoreUserVal.whenOrNull(
      data: (data) => data.data(),
    );

    return FirebaseUserNotifier(firebaseUser);
  },
);

// ignore: prefer-static-class
final currentFirestoreUserStreamProvider =
    StreamProvider.autoDispose<QuerySnapshot<FirestoreAlmanakProfile>>((ref) {
  final user = ref.watch(firebaseAuthUserProvider);

  return FirebaseFirestore.instance
      .collection('people')
      .withConverter<FirestoreAlmanakProfile>(
        fromFirestore: (snapshot, _) =>
            FirestoreAlmanakProfile.fromFirestore(snapshot.data() ?? {}),
        toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
      )
      // ignore: avoid-non-null-assertion
      .where('identifier', isEqualTo: user!.uid)
      .limit(1)
      .snapshots();
});

// ignore: prefer-static-class
final firestoreUserProvider = StateNotifierProvider.family<FirebaseUserNotifier,
    FirestoreAlmanakProfile?, String>(
  (ref, userId) {
    final curUser = ref.watch(firebaseAuthUserProvider);

    if (curUser == null) return FirebaseUserNotifier(null);

    final firestoreUserVal = ref.watch(firestoreUserFutureProvider(userId));

    final FirestoreAlmanakProfile? firebaseUser = firestoreUserVal.whenOrNull(
      data: (data) => data.data(),
    );

    return FirebaseUserNotifier(firebaseUser);
  },
);
