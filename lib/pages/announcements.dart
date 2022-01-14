import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/pages/announcement.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';

double titleFontSize = 28;
double contentFontSize = 22;
double paddingBody = 10;

class AnnouncementsPage extends HookConsumerWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Aankondigingen'),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: false,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
        body: const Announcements(amount: 10)); // show first 10 announcments
  }
}

class Announcements extends HookConsumerWidget {
  const Announcements({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String query = '''
      query announcements {
        announcements(first: $amount) {
          data {
            id,
            title
          }
        }
      }
    ''';
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(document: gql(query));
    final Future<QueryResult> result = client.query(options);
    return FutureBuilder(
      future: result,
      builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('not started');
          case ConnectionState.waiting:
            return const Loading();
          default:
            var announcementsList =
                snapshot.data?.data?['announcements']['data'];
            return Padding(
              // Add padding to whole body
              padding: EdgeInsets.all(paddingBody),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: announcementsList.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 5, // give more card-like feel
                    child: ListTile(
                      title: Text(
                        announcementsList[index]['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnnouncementPage(
                                  announcementId: announcementsList[index]
                                      ['id'])),
                        );
                      },
                    ),
                  );
                },
              ),
            );
        }
      },
    );
  }
}
