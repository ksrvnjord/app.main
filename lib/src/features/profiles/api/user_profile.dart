import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

// retrieves all data from firestore and heimdall for a given user
final almanakUserProvider =
    FutureProvider.family<AlmanakProfile, String>((ref, lidnummer) async {
  if (FirebaseAuth.instance.currentUser == null) {
    // if in DEMO mode, the lidnummer is the heimdall id
    final profile = await ref.watch(heimdallUserByIdProvider(lidnummer).future);

    return AlmanakProfile.fromHeimdall(profile!);
  }

  // call both queries in parallel
  final heimdallProfile =
      ref.watch(heimdallUserByLidnummerProvider(lidnummer).future);

  AlmanakProfile? profile =
      await ref.watch(firestoreUserProvider(lidnummer).future);
  final heimdallProfileData = await heimdallProfile;

  // merge the data
  profile?.mergeWithHeimdallProfile(heimdallProfileData!.fullContact.public);

  return profile ??
      AlmanakProfile.fromHeimdallByIdentifier(
        heimdallProfileData!,
      ); // if no profile was found in firestore, return the heimdall profile
});

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
