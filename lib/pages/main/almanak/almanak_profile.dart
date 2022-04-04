import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_info/static_user_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_avatar.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import 'package:ksrvnjord_main_app/widgets/utilities/development_feature.dart';

const String user = r'''
  query ($profileId: ID!) {
    user (id: $profileId) {
      identifier,
      email,
      username,
      contact {
        first_name,
        last_name
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
    final QueryOptions options =
        QueryOptions(document: gql(user), variables: {'profileId': profileId});
    final Future<QueryResult> result = client.query(options);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profiel'),
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
        ),
        body: FutureBuilder(
            future: result,
            builder:
                (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Loading();
                case ConnectionState.waiting:
                  return const Loading();
                default:
                  var user = snapshot.data?.data?['user'];

                  return ListView(children: <Widget>[
                    const Center(child: UserAvatar()),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    StaticUserField(
                        'Naam',
                        (user != null
                                ? (user['contact']['first_name'] ?? '-')
                                : '-') +
                            ' ' +
                            (user != null
                                ? (user['contact']['last_name'] ?? '-')
                                : '-')),
                    // TODO: non-default public
                    DevelopmentFeature(
                        child: StaticUserField('E-mailadres',
                            user != null ? (user['email'] ?? '-') : '-')),
                    StaticUserField('Njord-account',
                        user != null ? (user['username'] ?? '-') : '-'),
                  ]);
              }
            }));
  }
}
