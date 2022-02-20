import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_info/static_user_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_avatar.dart';

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

  final int profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(
        document: gql(users), variables: {'identifier': profileId});
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
              var ind = snapshot.data?.data?['users']['data']
                  .indexWhere((element) => element['identifier'] == profileId);
              var user = snapshot.data?.data?['users']['data'][ind];
              // TODO: Dit efficienter maken
              print(user['identifier'].runtimeType);
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Profile'),
                ),
                body: ListView(children: <Widget>[
                  const Center(child: UserAvatar()),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  StaticUserField('Naam', user['name'] ?? '-'),
                  StaticUserField(
                      'Lidnummer', (user['identifier'] ?? '-').toString()),
                  StaticUserField('E-mailadres', user['email'] ?? '-'),
                  //  StaticUserField('Telefoonnummer', user['phone_sms'] ?? '-'),
                  StaticUserField('Njord-account', user['username'] ?? '-'),
                ]),
              );
          }
        });
  }
}
