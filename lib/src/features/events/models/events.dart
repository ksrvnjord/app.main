import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/events/api/events.graphql.dart';

Future<List<Query$CalendarItems$events?>> events(GraphQLClient client) async {
  final result = await client.query$CalendarItems();
  final parsedData = result.parsedData;

  return parsedData?.events ?? [];
}
