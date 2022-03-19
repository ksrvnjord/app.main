import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/widgets/almanak/almanak_list.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import 'package:ksrvnjord_main_app/widgets/utilities/development_feature.dart';
import 'almanak_search.dart';
import 'almanak_profile.dart';
import 'package:ksrvnjord_main_app/widgets/general/searchbar.dart';

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
            title: const Text('Almanak'),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: false,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
        body: const Loading());
  }
}

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
              return _LoadingScreen();
            case ConnectionState.waiting:
              return _LoadingScreen();
            default:
              if (snapshot.hasError) {
                return _LoadingScreen();
              }

              List<dynamic> users = snapshot.data?.data?['users']['data'];
              List<Map<String, String>> names = users.map((e) {
                String id = e['id'].toString();
                String name = (e['contact']['first_name'] ?? '-') +
                    " " +
                    (e['contact']['last_name'] ?? '-');
                return {id: name};
              }).toList();

              return Builder(
                // Wrap in a Builder widget to get the right context for showSearch.
                builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Almanak'),
                      automaticallyImplyLeading: false,
                      actions: [
                        DevelopmentFeature(
                            child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AlmanakSearch()));
                          },
                          icon: const Icon(Icons.search),
                        ))
                      ],
                      backgroundColor: Colors.lightBlue,
                      shadowColor: Colors.transparent,
                    ),
                    body: AlmanakListView(users)),
              );
          }
        });
  }
}
