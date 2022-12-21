import 'package:graphql/client.dart';
import '../api/announcement.graphql.dart';

Future<Query$Announcement$announcement?> announcement(
    String announcementId, GraphQLClient client) async {
  final result = await client.query$Announcement(Options$Query$Announcement(
      variables: Variables$Query$Announcement(announcementId: announcementId)));

  final parsedData = result.parsedData;
  
  return parsedData?.announcement;
}
