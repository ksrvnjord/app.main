// ignore_for_file: prefer-static-class

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';

/// Retrieves all data from firestore and heimdall for the current user.
final currentUserProvider = StreamProvider.autoDispose<User>(
  (ref) async* {
    final user = ref.watch(firebaseAuthUserProvider).value;

    if (user == null) {
      return;
    }

    final profile = await ref.watch(userProvider(user.uid).future);

    yield profile;
  },
);

// ignore: prefer-match-file-name
class UserNotifier extends StateNotifier<User?> {
  UserNotifier(User? user) : super(user);
}

final currentUserNotifierProvider = StateNotifierProvider<UserNotifier, User?>(
  (ref) {
    final user = ref.watch(firebaseAuthUserProvider).value;

    if (user == null) {
      return UserNotifier(null);
    }

    final profile = ref.watch(userProvider(user.uid));

    return profile.when(
      data: (data) => UserNotifier(data),
      loading: () => UserNotifier(null),
      error: (err, stk) {
        FirebaseCrashlytics.instance.recordError(err, stk);

        return UserNotifier(null);
      },
    );
  },
);

/// Retrieves all data from firestore and heimdall for a given user.
final userProvider = StreamProvider.family<User, String>(
  (ref, lidnummer) async* {
    final user = ref.watch(firebaseAuthUserProvider).value;

    if (user == null) {
      // If in DEMO mode, the lidnummer is the heimdall id.
      final profile = await DjangoUser.getById(lidnummer, ref);

      yield User(django: profile);

      return;
    }

    // Call both queries in parallel.
    final heimdallFuture = DjangoUser.getByIdentifier(lidnummer, ref);
    final firestoreFuture =
        ref.watch(firestoreUserStreamProvider(lidnummer).future);

    final firestoreUserSnapshot = await firestoreFuture;
    final djangoUser = await heimdallFuture;

    // Merge the data.

    yield User(
      firestore: firestoreUserSnapshot.docs.first.data(),
      django: djangoUser,
    );
  },
);
