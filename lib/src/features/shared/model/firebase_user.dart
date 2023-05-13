import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

@immutable
class FirebaseUser {
  final String uid;
  final bool isBestuur;

  const FirebaseUser({
    required this.uid,
    required this.isBestuur,
  });

  bool get isAppCo => ['21203', '18031', '18257'].contains(uid);

  FirebaseUser copyWith({
    String? uid,
    bool? isBestuur,
  }) {
    return FirebaseUser(
      uid: uid ?? this.uid,
      isBestuur: isBestuur ?? this.isBestuur,
    );
  }
}

class FirebaseUserNotififier extends StateNotifier<FirebaseUser?> {
  FirebaseUserNotififier(FirebaseUser? user) : super(user);
}

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
      ),
    );

    return FirebaseUserNotififier(firebaseUser);
  },
);

final firestoreUserProvider =
    StateNotifierProvider.family<FirebaseUserNotififier, FirebaseUser?, String>(
  (ref, userId) {
    final curUser = ref.watch(firebaseAuthUserProvider);

    if (curUser == null) return FirebaseUserNotififier(null);

    final firestoreUserVal = ref.watch(firestoreUserFutureProvider(userId));

    final FirebaseUser? firebaseUser = firestoreUserVal.whenOrNull(
      data: (snapshot) => FirebaseUser(
        uid: snapshot.data().lidnummer,
        isBestuur: snapshot.data().bestuursFunctie != null,
      ),
    );

    return FirebaseUserNotififier(firebaseUser);
  },
);
