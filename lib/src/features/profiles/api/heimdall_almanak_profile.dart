import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

// ignore: prefer-static-class
final heimdallAlmanakProfileProvider = FutureProvider.family<
    Query$AlmanakProfileByIdentifier$userByIdentifier?,
    String>((ref, profileId) async {
  final client = ref.watch(graphQLModelProvider).client;
  final result = await client.query$AlmanakProfileByIdentifier(
    Options$Query$AlmanakProfileByIdentifier(
      variables:
          Variables$Query$AlmanakProfileByIdentifier(profileId: profileId),
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ),
  );

  final parsedData = result.parsedData;

  return parsedData?.userByIdentifier;
});
