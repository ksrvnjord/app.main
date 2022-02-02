import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';

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

class AlmanakProfile extends HookConsumerWidget {
  const AlmanakProfile({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(
        document: gql(users),
        variables: {'identifier': profileId}
    );
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
          var user = snapshot.data?.data?['users']['data'];
          print(user);

          return Scaffold(
              appBar: AppBar(
              title: const Text('Profile'),
              ),
              body: Card(
                child: Text('Hello'),
              ),
          );
        }
      },
    );
  }
}