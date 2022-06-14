import 'package:ksrvnjord_main_app/pages/main/announcements/announcement.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const double titleSize = 20;

class Announcements extends HookConsumerWidget {
  const Announcements({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String nFirstAnnouncements = '''
      query announcements {
        announcements(first: $amount) {
          data {
            id,
            title,
            author
          }
        }
      }
    ''';
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options =
        QueryOptions(document: gql(nFirstAnnouncements));
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
                    elevation: 3, // give more card-like feel
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: <Widget>[
                            Row(children: <Widget>[
                              Text(
                                announcementsList[index]['author'] ?? '',
                                style: const TextStyle(
                                  fontSize: titleSize - 4,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        announcementsList[index]['title'] ?? '',
                                        maxLines: 2,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  const Icon(Icons.arrow_forward_ios)
                                ]),
                          ]),
                      ),
                       onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnnouncementPage(
                                    announcementId: announcementsList[index]
                                        ['id'])),
                          );
                        }
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

// ListTile(
//                       title: Text(
//                         announcementsList[index]['title'] ?? '',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: titleSize),
//                       ),
//                       subtitle: Text(
//                         announcementsList[index]['author'] ?? '',
//                         style: const TextStyle(
//                           // TODO: aanpassen naar app stijl.
//                         )
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => AnnouncementPage(
//                                   announcementId: announcementsList[index]
//                                       ['id'])),
//                         );
//                       },
//                     ),
