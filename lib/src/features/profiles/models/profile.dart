import 'package:graphql/client.dart';

import '../api/profile.graphql.dart';

Future<Query$AlmanakProfile$user?> almanakProfile(
  String profileId,
  GraphQLClient client,
) async {
  final result = await client.query$AlmanakProfile(Options$Query$AlmanakProfile(
    variables: Variables$Query$AlmanakProfile(profileId: profileId),
    fetchPolicy: FetchPolicy.noCache,
  ));

  final parsedData = result.parsedData;

  return parsedData?.user;
}
