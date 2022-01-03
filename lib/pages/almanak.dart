import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql/client.dart';
import 'package:ksrv_njord_app/providers/heimdall.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import './almanak_profile.dart';
import 'package:ksrv_njord_app/widgets/general/searchbar.dart';

List<String> voorbeeldLeden = ['Boone', // Replace with info from the database.
  'Kristie',
  'Mark'];

const String users = r'''
  query users {
      data {
        identifier,
        name,
        email,
        username
      }
    }
''';

class AlmanakPage extends HookConsumerWidget {
  const AlmanakPage({Key? key}) : super(key: key);

  @override
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
              var userList = snapshot.data?.data?['users']['data'];
              return MaterialApp(
                title: 'Almanak',
                home: Builder( // Wrap in a Builder widget to get the right context for showSearch.
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Row(
                        children: [
                          Text('Almanak'),
                          IconButton(
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: CustomSearchDelegate(
                                    userList['name']
                                ),
                              );
                            },
                            icon: const Icon(Icons.search))
                        ],
                      ),
                      backgroundColor: Colors.lightBlue,
                      shadowColor: Colors.transparent,
                    ),
                    body: ListView.builder(
                      itemCount: voorbeeldLeden.length,
                      itemBuilder: (context, index) {
                        final lid = userList[index]['name'];
                        return ListTile(
                          title: Text(lid),
                          onTap: () {
                            print(lid);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => AlmanakPage(),
                            //   )
                            // );
                          },
                      );
                    },
                  ),
                ),
                ),
              );
          }
        }
    );
  }
}