import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

// retrieves all data from firestore and heimdall for a given user
final almanakUserProvider = FutureProvider
    .family<AlmanakProfile, String>((ref, identifier) async {
  final client = ref.watch(graphQLModelProvider).client;
  if (FirebaseAuth.instance.currentUser == null) {
    // if in DEMO mode
    return AlmanakProfile.fromHeimdall(
      (await almanakProfile(identifier, client))!,
    );
  }

  // call both queries in parallel
  Future<Query$AlmanakProfileByIdentifier$userByIdentifier?> heimdallProfile =
      almanakProfileByIdentifier(identifier, client);

  AlmanakProfile? profile = await getFirestoreProfileData(identifier);
  final heimdallProfileData = await heimdallProfile;

  // merge the data
  profile?.mergeWithHeimdallProfile(heimdallProfileData!.fullContact.public);

  return profile ??
      AlmanakProfile.fromHeimdallByIdentifier(
        heimdallProfileData!,
      ); // if no profile was found in firestore, return the heimdall profile
});
