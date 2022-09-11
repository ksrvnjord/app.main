import 'package:graphql/client.dart';
import '../api/me.graphql.dart';

Future<Query$Me$me?> me(GraphQLClient client) async {
  final result = await client.query$Me();

  final parsedData = result.parsedData;
  return parsedData?.me;
}
