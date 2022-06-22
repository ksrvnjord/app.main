import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String announcement = r'''
  query announcement($id: ID!) {
    announcement(id: $id) {
      id,
      title,
      contents,
      author
    }
  }
''';

double titleFontSize = 28;
double contentFontSize = 22;
double paddingBody = 10;

class AnnouncementPage extends HookConsumerWidget {
  const AnnouncementPage({
    Key? key,
    required this.announcementId,
  }) : super(key: key);

  final String announcementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(
        document: gql(announcement), variables: {'id': announcementId});
    final Future<QueryResult> result = client.query(options);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Aankondiging'),
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
        ),
        body: FutureBuilder(
          future: result,
          builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('not started');
              case ConnectionState.waiting:
                return const Loading();
              default:
                var announcement = snapshot.data?.data?['announcement'];
                return Padding(
                  // Add padding to whole body
                  padding: EdgeInsets.all(paddingBody),
                  child: ListView(
                    children: [
                      Row(children: <Widget>[
                        Text(
                          announcement?['author'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // TODO: also list author affiliation, e.g. 'Bestuur'
                      ]),
                      MarkdownBody(
                        data: announcement?['contents'] ?? "",
                        onTapLink: (text, url, title) {
                          // Check if an URL is actually given
                          if (url?.isNotEmpty ?? false) {
                            // Launch the URL
                            launchUrlString(url!);
                          }
                        },
                      ),
                    ],
                  ),
                );
            }
          },
        ));
  }
}
