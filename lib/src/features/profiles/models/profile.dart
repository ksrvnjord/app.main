import 'package:graphql/client.dart';

import '../api/profile.graphql.dart';
import '../api/profile_by_identifier.graphql.dart';

Future<Query$AlmanakProfile$user?> almanakProfile(
  String profileId,
  GraphQLClient client,
) async {
  final result = await client.query$AlmanakProfile(
    Options$Query$AlmanakProfile(
      variables: Variables$Query$AlmanakProfile(profileId: profileId),
      fetchPolicy: FetchPolicy.noCache,
    ),
  );

  final parsedData = result.parsedData;

  return parsedData?.user;
}

Future<Query$AlmanakProfileByIdentifier$userByIdentifier?>
    almanakProfileByIdentifier(
  String profileId,
  GraphQLClient client,
) async {
  final result = await client.query$AlmanakProfileByIdentifier(
    Options$Query$AlmanakProfileByIdentifier(
      variables:
          Variables$Query$AlmanakProfileByIdentifier(profileId: profileId),
      fetchPolicy: FetchPolicy.noCache,
    ),
  );

  final parsedData = result.parsedData;

  return parsedData?.userByIdentifier;
}
