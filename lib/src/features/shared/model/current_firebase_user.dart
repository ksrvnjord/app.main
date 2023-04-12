import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/api/firebase_currentuser_provider.dart';

@immutable
class CurrentFirebaseUser {
  final String uid;
  final bool isBestuur;

  const CurrentFirebaseUser({
    required this.uid,
    required this.isBestuur,
  });

  CurrentFirebaseUser copyWith({
    String? uid,
    bool? isBestuur,
  }) {
    return CurrentFirebaseUser(
      uid: uid ?? this.uid,
      isBestuur: isBestuur ?? this.isBestuur,
    );
  }
}

class CurrentFirebaseUserNotififier
    extends StateNotifier<CurrentFirebaseUser?> {
  CurrentFirebaseUserNotififier(CurrentFirebaseUser? user) : super(user);
}

final currentFirebaseUserProvider =
    StateNotifierProvider<CurrentFirebaseUserNotififier, CurrentFirebaseUser?>(
  (ref) {
    final user = ref.watch(firebaseAuthUserProvider);

    if (user == null) return CurrentFirebaseUserNotififier(null);

    final firestoreUserVal = ref.watch(firestoreUserProvider(user.uid));

    final CurrentFirebaseUser? firebaseUser = firestoreUserVal.whenOrNull(
      data: (data) => CurrentFirebaseUser(
        uid: user.uid,
        isBestuur: data.bestuursFunctie != null,
      ),
    );

    return CurrentFirebaseUserNotififier(firebaseUser);
  },
);
