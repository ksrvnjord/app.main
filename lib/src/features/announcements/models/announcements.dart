import 'package:graphql/client.dart';
import '../api/announcements.graphql.dart';

Future<Query$Announcements?> announcements(
  GraphQLClient client, {
  int page = 0,
}) async {
  final result = await client.query$Announcements(Options$Query$Announcements(
    variables: Variables$Query$Announcements(
      page: page,
    ),
  ));

  return result.parsedData;
}
