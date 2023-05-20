import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcement.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/announcements/api/announcements.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';

// Get first page of announcements.
// For now we have one provider for announcements, when we have multiple consider putting them in a class.
// ignore: prefer-static-class
abstract class Announcements {
  static final firstPageProvider =
      FutureProvider<List<Query$Announcements$announcements$data>?>(
    (ref) async {
      final client = ref.watch(graphQLModelProvider).client;
      final result =
          await client.query$Announcements(Options$Query$Announcements(
        variables: Variables$Query$Announcements(
          page: 0,
        ),
      ));

      return result.parsedData?.announcements?.data;
    },
  );

  static final getByIdProvider =
      FutureProvider.family<Query$Announcement$announcement, String>(
    (ref, announcementId) async {
      final client = ref.watch(graphQLModelProvider).client;
      final result = await client.query$Announcement(Options$Query$Announcement(
        variables: Variables$Query$Announcement(announcementId: announcementId),
      ));

      final parsedData = result.parsedData;

      return parsedData?.announcement as Query$Announcement$announcement;
    },
  );
}
