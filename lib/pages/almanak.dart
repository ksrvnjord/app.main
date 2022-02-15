import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import './almanak_profile.dart';
import 'package:ksrvnjord_main_app/widgets/general/searchbar.dart';

const String users = r'''
  query {
    users {
      data {
        identifier,
        email,
        username,
        contact {
          first_name,
          last_name
        }
      }
    }
  }
''';

class AlmanakPage extends HookConsumerWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(document: gql(users));
    final Future<QueryResult> result = client.query(options);

    return FutureBuilder(
        future: result,
        builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('not started');
            case ConnectionState.waiting:
              return const Text('loading');
            default:
              if (snapshot.hasError) {
                return const Loading();
              }

              List<dynamic> users = snapshot.data?.data?['users']['data'];
              List<Map<int, String>> names = users.map((e) {
                int identifier = e['identifier'];
                String name = (e['contact']['first_name'] ?? '-') +
                    " " +
                    (e['contact']['last_name'] ?? '-');
                return {identifier: name};
              }).toList();

              return MaterialApp(
                title: 'Almanak',
                home: Builder(
                  // Wrap in a Builder widget to get the right context for showSearch.
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Almanak'),
                      actions: [
                        IconButton(
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: CustomSearchDelegate(names),
                            );
                          },
                          icon: const Icon(Icons.search),
                        )
                      ],
                      backgroundColor: Colors.lightBlue,
                      shadowColor: Colors.transparent,
                    ),
                    body: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text((users[index]['contact']['first_name'] ??
                                  '-') +
                              ' ' +
                              (users[index]['contact']['last_name'] ?? '-')),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlmanakProfile(
                                      profileId: users[index]['identifier']),
                                ));
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
          }
        });
  }
}
