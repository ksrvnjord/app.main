import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import './almanak_profile.dart';
import 'package:ksrvnjord_main_app/widgets/general/searchbar.dart';

const String users = r'''
  query {
    users {
      data {
        identifier,
        name,
        email,
        username
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
              var userList = snapshot.data?.data?['users']['data'];
              List<String> names = [];
              for (var i = 0; i < userList.length; i++) { // TODO: Dit is heel lelijk.

                names.add(userList[i]['name']);
              }

              return MaterialApp(
                title: 'Almanak',
                 home: Builder( // Wrap in a Builder widget to get the right context for showSearch.
                   builder: (context) => Scaffold(
                     appBar: AppBar(
                       title: Text('Almanak'),
                       actions: [
                         IconButton(
                           onPressed: () {
                             showSearch(
                               context: context,
                               delegate: CustomSearchDelegate(
                                   names
                                ),
                              );
                             },
                           icon: const Icon(Icons.search),
                         )
                       ],

                       backgroundColor: Colors.lightBlue,
                       shadowColor: Colors.transparent,
                     ),
                     body: ListView.builder(
                       itemCount: userList.length,
                       itemBuilder: (context, index) {

                         return ListTile(
                           title: Text(userList[index]['name']),
                           onTap: () {
                             Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlmanakProfile(
                                      profileId: userList[userList[index]['identifier']]),
                                )
                              );
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