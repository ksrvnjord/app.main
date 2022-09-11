import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import '../api/almanak.graphql.dart';

Future<Query$Almanak$users?> almanakUsers(
    int first, int page, GraphQLClient client) async {
  final result = await client.query$Almanak(Options$Query$Almanak(
      variables: Variables$Query$Almanak(page: page, first: first)));

  final parsedData = result.parsedData;
  return parsedData?.users;
}
