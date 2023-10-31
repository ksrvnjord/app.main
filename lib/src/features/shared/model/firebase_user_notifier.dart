import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';

class FirebaseUserNotifier extends StateNotifier<FirestoreAlmanakProfile?> {
  FirebaseUserNotifier(FirestoreAlmanakProfile? user) : super(user);
}

// ignore: prefer-static-class
final currentFirestoreUserProvider =
    StateNotifierProvider<FirebaseUserNotifier, FirestoreAlmanakProfile?>(
  (ref) {
    final user = ref.watch(firebaseAuthUserProvider).value;

    if (user == null) return FirebaseUserNotifier(null);

    final firestoreUserVal = ref.watch(currentfirestoreUserStreamProvider);

    final FirestoreAlmanakProfile? firebaseUser = firestoreUserVal.whenOrNull(
      data: (data) => data.docs.first.data(),
    );

    return FirebaseUserNotifier(firebaseUser);
  },
);

// ignore: prefer-static-class
final currentFirestoreUserStreamProvider =
    StreamProvider<QuerySnapshot<FirestoreAlmanakProfile>>((ref) {
  final user = ref.watch(firebaseAuthUserProvider).value;

  return user == null
      ? const Stream.empty()
      : peopleCollection
          // ignore: avoid-non-null-assertion
          .where('identifier', isEqualTo: user.uid)
          .limit(1)
          .snapshots();
});

// ignore: prefer-static-class
final firestoreUserProvider = StateNotifierProvider.autoDispose
    .family<FirebaseUserNotifier, FirestoreAlmanakProfile?, String>(
  (ref, userId) {
    final curUser = ref.watch(firebaseAuthUserProvider).value;

    if (curUser == null) return FirebaseUserNotifier(null);

    final firestoreUserVal = ref.watch(firestoreUserStreamProvider(userId));

    final FirestoreAlmanakProfile? firebaseUser = firestoreUserVal.whenOrNull(
      data: (data) => data.size > 0 ? data.docs.first.data() : null,
    );

    return FirebaseUserNotifier(firebaseUser);
  },
);
