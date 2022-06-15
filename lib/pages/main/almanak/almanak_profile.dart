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
      fullContact {
          public{
            first_name,
            last_name
            email,
            street,
            housenumber,
            housenumber_addition,
            city,
            zipcode,
          }
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
                  var user_contact = user['fullContact']['public'];

                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(child: UserAvatar()),
                        const SizedBox(height: 10),
                        if (user == null) ...{
                          const Text(
                              'The user retrieved from the database is empty'),
                        } else ...{
                          StaticUserField(
                              'Naam',
                              (user_contact['first_name'] ?? '-') +
                                  ' ' +
                                  (user_contact['last_name'] ??
                                      '-')), // TODO: non-default public

                          StaticUserField('E-mailadres', user['email']),
                          StaticUserField(
                              'Adres',
                              (user_contact['street'] ?? '-') +
                                  ' ' +
                                  (user_contact['housenumber'] ?? '') +
                                  ' ' +
                                  (user_contact['housenumber_addition'] ?? '')),

                          StaticUserField(
                              'Postcode', user_contact['zipcode'] ?? '-'),
                          StaticUserField(
                              'Woonplaats', user_contact['city'] ?? '-'),
                        },
                      ]));
              }
            }));
  }
}
