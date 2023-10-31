// ignore_for_file: prefer-static-class

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

/// Retrieves all data from firestore and heimdall for a given user.
final userProvider = StreamProvider.autoDispose.family<User, String>(
  (ref, lidnummer) async* {
    final user = ref.watch(firebaseAuthUserProvider).value;

    if (user == null) {
      // If in DEMO mode, the lidnummer is the heimdall id.
      final profile = await DjangoUser.getByIdGraphQL(lidnummer, ref);

      yield User(
        django: DjangoUser.fromHeimdallDemoEnv(profile),
      );

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
