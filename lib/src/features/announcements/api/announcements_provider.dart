import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

// Get first page of announcements.
final announcementsProvider =
    FutureProvider<List<Query$Announcements$announcements$data>?>((ref) async {
  final client = ref.watch(graphQLModelProvider).client;
  final result = await client.query$Announcements(Options$Query$Announcements(
    variables: Variables$Query$Announcements(
      page: 0,
    ),
  ));

  return result.parsedData?.announcements?.data;
});
