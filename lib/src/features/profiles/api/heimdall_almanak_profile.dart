import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_by_identifier.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

// ignore: prefer-static-class
final heimdallAlmanakProfileProvider = StreamProvider.autoDispose
    .family<Query$AlmanakProfileByIdentifier$userByIdentifier?, String>(
  (ref, profileId) async* {
    if (ref.watch(firebaseAuthUserProvider).value == null) {
      return;
    }

    final client = ref.watch(graphQLClientProvider);
    final result = await client.query$AlmanakProfileByIdentifier(
      Options$Query$AlmanakProfileByIdentifier(
        variables:
            Variables$Query$AlmanakProfileByIdentifier(profileId: profileId),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    final parsedData = result.parsedData;

    yield parsedData?.userByIdentifier;
  },
);
