import 'package:flutter/material.dart';
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
  Widget build(BuildContext context, WidgetRef ref){
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(document: gql(users));
    final Future<QueryResult> result = client.query(options);

    // Do I need a FutureBuilder method?
    // How do I read data from queries?
    // How do I get a query?

    return MaterialApp(
      title: "Almanak",
      home: Builder( // Wrap in a builder widget to get the right context for showSearch.
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text('Almanak'),
                IconButton( // Put in the title for now, needs styling later.
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(voorbeeldLeden), // Give the possible search terms as parameter to the search bar function.
                    );
                  },
                  icon: const Icon(Icons.search), // Use classic search icon.
                ),
              ],
            ),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
          ),
          body: ListView.builder(
            itemCount: voorbeeldLeden.length,
            itemBuilder: (context, index) {
              final lid = voorbeeldLeden[index];
              return ListTile(
                title: Text(lid),
                onTap: () {print(lid);
                 // Navigator.push(
                 // context,
                 // MaterialPageRoute(
                 //     builder: (context) => AlmanakPage(//        UserId: lid ['id'])),
               // );
              },
              );
              },
          ),
        )
      )
    );
  }
}