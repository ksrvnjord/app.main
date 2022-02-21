import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/authentication.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_info/static_user_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_info/amendable_user_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/groups/amendable_group_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_avatar.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';

double betweenFields = 20;
double marginContainer = 5;
double paddingBody = 15;

const String me = r'''
  query {
    me {
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

class MePage extends HookConsumerWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(document: gql(me));
    final Future<QueryResult> result = client.query(options);

    return Scaffold(
        appBar: AppBar(
            title: const Text('Jouw Njord-Account'),
            backgroundColor: Colors.lightBlue,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: true,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue)),
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
                  if (snapshot.hasError) {
                    return const Loading();
                  }

                  var user = snapshot.data?.data!['me'];
                  return MeWidget(user);
              }
            }));
  }
}

class MeWidget extends HookConsumerWidget {
  const MeWidget(this.user, {Key? key}) : super(key: key);

  final dynamic user;
  final Map groepen = {
    'commissies': [
      // 'Competitiecomissie',
      // 'Appcommissie',
      // 'Buffetcommissie',
      // 'Rowing blind'
    ],
    'ploegen': [], // ['EJD', 'EJZ', 'TopC4'],
    'verticalen': [] // ['Vanir', 'Heeren XII', 'Dames 6']
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(padding: EdgeInsets.all(paddingBody), children: <Widget>[
      const Center(child: UserAvatar()),
      const SizedBox(height: 10),
      const SizedBox(height: 20),
      StaticUserField('Lidnummer', user['identifier'].toString()),
      StaticUserField('Njord-account', user['username'] ?? '-'),
      const Divider(
        height: 64,
      ),
      AmendableGroupField('Ploegen', groepen['ploegen'] ?? '-'),
      AmendableGroupField('Commissies', groepen['commissies'] ?? '-'),
      AmendableGroupField('Verband/Verticaal/Dispuut', groepen['verticalen'] ?? '-'),
      const Divider(
        height: 64,
      ),
      AmendableUserField('Voornaam', user['contact']['first_name'] ?? '-'),
      AmendableUserField('Achternaam', user['contact']['last_name'] ?? '-'),
      AmendableUserField('E-mailadres', user['email'] ?? '-'),
      AmendableUserField(
          'Telefoonnummer', user['contact']['phone_primary'] ?? '-'),
      const Divider(
        height: 64,
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.red,
              onPressed: () {
                ref.read(authenticationProvider).logout();
              },
            ),
            const Text('Uitloggen', style: TextStyle(color: Colors.red))
          ])
    ]);
  }
}
