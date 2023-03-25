import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

// retrieves all data from firestore and heimdall for a given user
final almanakUserProvider = FutureProvider.autoDispose
    .family<AlmanakProfile, String>((ref, identifier) async {
  final client = ref.watch(graphQLModelProvider).client;

  // call both queries in parallel
  Future<Query$AlmanakProfileByIdentifier$userByIdentifier?> heimdallProfile =
      almanakProfileByIdentifier(identifier, client);
  Future<AlmanakProfile> firestoreProfile = getFirestoreProfileData(identifier);
  // await for both futures
  final firestoreProfileData = await firestoreProfile;
  final heimdallProfileData = await heimdallProfile;

  // merge the data
  firestoreProfileData
      .mergeWithHeimdallProfile(heimdallProfileData!.fullContact.public);

  return firestoreProfileData;
});
