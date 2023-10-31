// ignore_for_file: prefer-static-class
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

/// Retrieves all data from firestore and heimdall for a given user.
final userProvider =
    StreamProvider.autoDispose.family<FirestoreAlmanakProfile, String>(
  (ref, lidnummer) async* {
    final user = ref.watch(firebaseAuthUserProvider).value;

    if (user == null) {
      // If in DEMO mode, the lidnummer is the heimdall id.
      final profile =
          await ref.watch(heimdallUserByIdProvider(lidnummer).future);

      yield FirestoreAlmanakProfile.fromHeimdall(profile);

      return;
    }

    // Call both queries in parallel.
    final heimdallProfile =
        ref.watch(heimdallUserByLidnummerProvider(lidnummer).future);

    FirestoreAlmanakProfile profile =
        (await ref.watch(firestoreUserStreamProvider(lidnummer).future))
            .docs
            .first
            .data();
    final heimdallProfileData = await heimdallProfile;

    // Merge the data.
    final heimdallProfilePublic = heimdallProfileData?.fullContact.public;

    final street = heimdallProfilePublic?.street;
    final houseNumber = heimdallProfilePublic?.housenumber;
    final houseNumberAddition = heimdallProfilePublic?.housenumber_addition;
    final postalCode = heimdallProfilePublic?.zipcode;
    final city = heimdallProfilePublic?.city;

    yield profile.copyWith(
      email: heimdallProfilePublic?.email,
      phonePrimary: heimdallProfilePublic?.phone_primary,
      address: street != null ||
              houseNumber != null ||
              city != null ||
              postalCode != null
          ? Address(
              street: street,
              houseNumber: houseNumber,
              houseNumberAddition: houseNumberAddition,
              postalCode: postalCode,
              city: city,
            )
          : null,
    );
  },
);

/// Retrieves all data from firestore and heimdall for the current user.
final currentUserProvider = StreamProvider.autoDispose<FirestoreAlmanakProfile>(
  (ref) async* {
    final user = ref.watch(firebaseAuthUserProvider).value;

    if (user == null) {
      return;
    }

    final profile = await ref.watch(userProvider(user.uid).future);

    yield profile;
  },
);

final heimdallUserByLidnummerProvider = StreamProvider.family<
    Query$AlmanakProfileByIdentifier$userByIdentifier?, String>(
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
