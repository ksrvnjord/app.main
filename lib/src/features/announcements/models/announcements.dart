import 'package:graphql/client.dart';
import '../api/announcements.graphql.dart';

Future<Query$Announcements?> announcements(
  int? page,
  GraphQLClient client,
) async {
  final result = await client.query$Announcements(Options$Query$Announcements(
    variables: Variables$Query$Announcements(
      page: page ?? 0,
    ),
  ));

  return result.parsedData;
}
