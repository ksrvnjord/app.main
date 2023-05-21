import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

@immutable
class FirebaseUser {
  final String uid;
  final bool isBestuur;
  final String firstName;
  final String lastName;

  bool get isAppCo => ['21203', '18031', '18257'].contains(uid);

  const FirebaseUser({
    required this.uid,
    required this.isBestuur,
    required this.firstName,
    required this.lastName,
  });

  FirebaseUser copyWith({
    String? uid,
    bool? isBestuur,
    String? firstName,
    String? lastName,
  }) {
    return FirebaseUser(
      uid: uid ?? this.uid,
      isBestuur: isBestuur ?? this.isBestuur,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}

class FirebaseUserNotififier extends StateNotifier<FirebaseUser?> {
  FirebaseUserNotififier(FirebaseUser? user) : super(user);
}

// ignore: prefer-static-class
final currentFirebaseUserProvider =
    StateNotifierProvider<FirebaseUserNotififier, FirebaseUser?>(
  (ref) {
    final user = ref.watch(firebaseAuthUserProvider);

    if (user == null) return FirebaseUserNotififier(null);

    final firestoreUserVal = ref.watch(firestoreUserFutureProvider(user.uid));

    final FirebaseUser? firebaseUser = firestoreUserVal.whenOrNull(
      data: (data) => FirebaseUser(
        uid: user.uid,
        isBestuur: data.data().bestuursFunctie != null,
        firstName: data.data().firstName,
        lastName: data.data().lastName,
      ),
    );

    return FirebaseUserNotififier(firebaseUser);
  },
);

// ignore: prefer-static-class
final currentFirestoreUserStreamProvider =
    StreamProvider<QuerySnapshot<FirestoreAlmanakProfile>>((ref) {
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
final firestoreUserProvider =
    StateNotifierProvider.family<FirebaseUserNotififier, FirebaseUser?, String>(
  (ref, userId) {
    final curUser = ref.watch(firebaseAuthUserProvider);

    if (curUser == null) return FirebaseUserNotififier(null);

    final firestoreUserVal = ref.watch(firestoreUserFutureProvider(userId));

    final FirebaseUser? firebaseUser = firestoreUserVal.whenOrNull(
      data: (snapshot) => FirebaseUser(
        uid: snapshot.data().identifier,
        isBestuur: snapshot.data().bestuursFunctie != null,
        firstName: snapshot.data().firstName,
        lastName: snapshot.data().lastName,
      ),
    );

    return FirebaseUserNotififier(firebaseUser);
  },
);
