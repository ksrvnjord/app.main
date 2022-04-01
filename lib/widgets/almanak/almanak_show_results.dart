import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/almanak/almanak_list.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';

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
    return const Loading();
  }
}

class ShowResults extends StatefulHookConsumerWidget {
  final Stream<String> stream;

  const ShowResults({Key? key, required this.stream}) : super(key: key);

  @override
  _ShowResultsState createState() => _ShowResultsState();
}

class _ShowResultsState extends ConsumerState<ShowResults> {
  String currentSearch = '';

  @override
  void initState() {
    super.initState();
    widget.stream.listen((text) {
      setState(() {
        currentSearch = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(
        document: gql(users), variables: {'search': currentSearch});
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

              return (AlmanakListView(users));
          }
        });
  }
}
