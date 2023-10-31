// ignore_for_file: prefer-static-class
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

/// Retrieves all data from firestore and heimdall for a given user.
final userProvider = StreamProvider.autoDispose.family<User, String>(
  (ref, lidnummer) async* {
    final user = ref.watch(firebaseAuthUserProvider).value;

    if (user == null) {
      // If in DEMO mode, the lidnummer is the heimdall id.
      final profile =
          await ref.watch(heimdallUserByIdProvider(lidnummer).future);

      yield User(
        django: DjangoUser.fromHeimdallDemoEnv(profile),
      );

      return;
    }

    // Call both queries in parallel.
    final heimdallFuture =
        ref.watch(heimdallUserByLidnummerProvider(lidnummer).future);

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

final heimdallUserByLidnummerProviderGraphQL = StreamProvider.autoDispose
    .family<Query$AlmanakProfileByIdentifier$userByIdentifier?, String>(
  (ref, identifier) async* {
    // ignore: avoid-ignoring-return-values
    ref.watch(firebaseAuthUserProvider);

    final client = ref.watch(graphQLClientProvider);

    final result = await client.query$AlmanakProfileByIdentifier(
      Options$Query$AlmanakProfileByIdentifier(
        variables:
            Variables$Query$AlmanakProfileByIdentifier(profileId: identifier),
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    yield result.parsedData?.userByIdentifier;
  },
);

final heimdallUserByLidnummerProvider =
    StreamProvider.autoDispose.family<DjangoUser, String>(
  (ref, identifier) async* {
    // ignore: avoid-ignoring-return-values
    ref.watch(firebaseAuthUserProvider);

    final dio = ref.watch(dioProvider);

    final res = await dio.get("/api/users/users/", queryParameters: {
      "search": identifier,
    });
    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final results = data["results"] as List;
    final user = results.first as Map<String, dynamic>;

    yield DjangoUser.fromJson(user);
  },
);

final heimdallUserByIdProvider =
    StreamProvider.autoDispose.family<Query$AlmanakProfile$user?, String>(
  (ref, heimdallId) async* {
    // ignore: avoid-ignoring-return-values
    ref.watch(firebaseAuthUserProvider);

    final client = ref.watch(graphQLClientProvider);

    final result = await client.query$AlmanakProfile(
      Options$Query$AlmanakProfile(
        variables: Variables$Query$AlmanakProfile(profileId: heimdallId),
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    yield result.parsedData?.user;
  },
);
