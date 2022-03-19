import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/almanak/almanak_list.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import 'package:ksrvnjord_main_app/widgets/utilities/development_feature.dart';
import 'package:flutter/services.dart';

import 'almanak_profile.dart';

const String users = r'''
  query {
    users {
      data {
        id,
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

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: false,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
        body: const Loading());
  }
}

class AlmanakSearch extends StatefulHookConsumerWidget {
  const AlmanakSearch({Key? key}) : super(key: key);

  @override
  _AlmanakSearchState createState() => _AlmanakSearchState();
}

class _AlmanakSearchState extends ConsumerState<AlmanakSearch> {
  TextEditingController currentSearch = TextEditingController();

  @override
  void initState() {
    currentSearch.text = ""; //Enter own name to see that still all are shown
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(
        document: gql(users), variables: {'search': currentSearch.text});
    final Future<QueryResult> result = client.query(options);

    return FutureBuilder(
        future: result,
        builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _LoadingScreen();
            case ConnectionState.waiting:
              return _LoadingScreen();
            default:
              if (snapshot.hasError) {
                return _LoadingScreen();
              }

              // Query here
              List<dynamic> users = snapshot.data?.data?['users']['data'];

              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.lightBlue,
                    shadowColor: Colors.transparent,
                    title: TextField(
                      autofocus: true,
                      controller: currentSearch,
                      onChanged: (text) {
                        setState(() {
                          currentSearch.text = text;
                        });
                      },
                    ),
                    actions: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            currentSearch.clear();
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    ],
                  ),
                  body: AlmanakListView(users));
          }
        });
  }
}
