import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/queries/queries/almanak_profile.dart'
    as query;
import 'package:ksrvnjord_main_app/widgets/me/user_info/static_user_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_avatar.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';

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
        document: gql(query.almanakProfileQuery),
        variables: {'profileId': profileId});
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
                  Map<String, dynamic> userPublicRaw =
                      user['fullContact']['public'];

                  Map<String, dynamic> userPublic =
                      userPublicRaw.map((key, value) {
                    value = value == '0' ? null : value;
                    return MapEntry(key, value);
                  });

                  List<String> labels = [
                    'Naam',
                    'Telefoonnummer',
                    'E-mailadres',
                    'Adres',
                    'Postcode',
                    'Woonplaats'
                  ];

                  List<String> values = [
                    (userPublic['first_name'] ?? '-') +
                        ' ' +
                        (userPublic['last_name'] ?? '-'),
                    userPublic['phone_primary'] ?? '-',
                    userPublic['email'] ?? '-',
                    (userPublic['street'] ?? '-') +
                        ' ' +
                        (userPublic['housenumber'] ?? '') +
                        (userPublic['housenumber_addition'] ?? ''),
                    userPublic['zipcode'] ?? '-',
                    userPublic['city'] ?? '-'
                  ];

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
                          SizedBox(
                              height: MediaQuery.of(context).size.height - 316,
                              child: ListView.builder(
                                  physics: const PageScrollPhysics(),
                                  itemCount: labels.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return StaticUserField(
                                        labels[index], values[index]);
                                  }))
                        }
                      ]));
              }
            }));
  }
}
