import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/address.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

// retrieves all data from firestore and heimdall for a given user
final almanakUserProvider =
    FutureProvider.autoDispose.family<FirestoreAlmanakProfile, String>(
  (ref, lidnummer) async {
    if (FirebaseAuth.instance.currentUser == null) {
      // if in DEMO mode, the lidnummer is the heimdall id
      final profile =
          await ref.watch(heimdallUserByIdProvider(lidnummer).future);

      return FirestoreAlmanakProfile.fromHeimdall(profile!);
    }

    // call both queries in parallel
    final heimdallProfile =
        ref.watch(heimdallUserByLidnummerProvider(lidnummer).future);

    FirestoreAlmanakProfile profile =
        (await ref.watch(firestoreUserFutureProvider(lidnummer).future)).data();
    final heimdallProfileData = await heimdallProfile;

    // merge the data
    final heimdallProfilePublic = heimdallProfileData!.fullContact.public;

    return profile.copyWith(
      email: heimdallProfilePublic.email,
      phonePrimary: heimdallProfilePublic.phone_primary,
      address: heimdallProfilePublic.street != null ||
              heimdallProfilePublic.housenumber != null ||
              heimdallProfilePublic.city != null ||
              heimdallProfilePublic.zipcode != null
          ? Address(
              street: heimdallProfilePublic.street,
              houseNumber: heimdallProfilePublic.housenumber,
              city: heimdallProfilePublic.city,
              postalCode: heimdallProfilePublic.zipcode,
              houseNumberAddition: heimdallProfilePublic.housenumber_addition,
            )
          : null,
    );
  },
);

final heimdallUserByLidnummerProvider = FutureProvider.family<
    Query$AlmanakProfileByIdentifier$userByIdentifier?,
    String>((ref, identifier) async {
  final client = ref.watch(graphQLModelProvider).client;

  final result = await client.query$AlmanakProfileByIdentifier(
    Options$Query$AlmanakProfileByIdentifier(
      variables:
          Variables$Query$AlmanakProfileByIdentifier(profileId: identifier),
      fetchPolicy: FetchPolicy.cacheFirst,
    ),
  );

  return result.parsedData?.userByIdentifier;
});

final heimdallUserByIdProvider =
    FutureProvider.family<Query$AlmanakProfile$user?, String>(
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
