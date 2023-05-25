// ignore_for_file: prefer-static-class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

// Retrieves all data from firestore and heimdall for a given user.
final almanakUserProvider =
    FutureProvider.autoDispose.family<FirestoreAlmanakProfile, String>(
  (ref, lidnummer) async {
    if (FirebaseAuth.instance.currentUser == null) {
      // If in DEMO mode, the lidnummer is the heimdall id.
      final profile =
          await ref.watch(heimdallUserByIdProvider(lidnummer).future);

      return FirestoreAlmanakProfile.fromHeimdall(profile);
    }

    // Call both queries in parallel.
    final heimdallProfile =
        ref.watch(heimdallUserByLidnummerProvider(lidnummer).future);

    FirestoreAlmanakProfile profile =
        (await ref.watch(firestoreUserFutureProvider(lidnummer).future)).data();
    final heimdallProfileData = await heimdallProfile;

    // Merge the data.
    final heimdallProfilePublic = heimdallProfileData?.fullContact.public;

    final street = heimdallProfilePublic?.street;
    final houseNumber = heimdallProfilePublic?.housenumber;
    final houseNumberAddition = heimdallProfilePublic?.housenumber_addition;
    final postalCode = heimdallProfilePublic?.zipcode;
    final city = heimdallProfilePublic?.city;

    return profile.copyWith(
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

final heimdallUserByLidnummerProvider = FutureProvider.autoDispose
    .family<Query$AlmanakProfileByIdentifier$userByIdentifier?, String>(
  (ref, identifier) async {
    final client = ref.watch(graphQLModelProvider).client;

    final result = await client.query$AlmanakProfileByIdentifier(
      Options$Query$AlmanakProfileByIdentifier(
        variables:
            Variables$Query$AlmanakProfileByIdentifier(profileId: identifier),
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    return result.parsedData?.userByIdentifier;
  },
);

final heimdallUserByIdProvider =
    FutureProvider.autoDispose.family<Query$AlmanakProfile$user?, String>(
  (ref, heimdallId) async {
    final client = ref.watch(graphQLModelProvider).client;

    final result = await client.query$AlmanakProfile(
      Options$Query$AlmanakProfile(
        variables: Variables$Query$AlmanakProfile(profileId: heimdallId),
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    return result.parsedData?.user;
  },
);
