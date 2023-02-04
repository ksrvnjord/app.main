import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/schema.graphql.dart';
import '../api/me.graphql.dart';

Future<Query$Me$me?> me(GraphQLClient client) async {
  final result =
      await client.query$Me(Options$Query$Me(fetchPolicy: FetchPolicy.noCache));

  final parsedData = result.parsedData;

  return parsedData?.me;
}

Future<Mutation$Me$updateContactDetails?> updateMe(
  GraphQLClient client,
  Input$IContact contact,
) async {
  final result = await client.mutate$Me(Options$Mutation$Me(
    fetchPolicy: FetchPolicy.noCache,
    variables: Variables$Mutation$Me(contact: contact),
  ));
  final parsedData = result.parsedData;

  return parsedData?.updateContactDetails;
}

Future<Mutation$UpdateVisibility$updatePublicContact?> updatePublicContact(
  GraphQLClient client,
  bool listed,
  Input$IBooleanContact contact,
) async {
  final result = await client.mutate$UpdateVisibility(
    Options$Mutation$UpdateVisibility(
      fetchPolicy: FetchPolicy.noCache,
      variables: Variables$Mutation$UpdateVisibility(
        listed: listed,
        contact: contact,
      ),
    ),
  );
  final parsedData = result.parsedData;

  return parsedData?.updatePublicContact;
}
