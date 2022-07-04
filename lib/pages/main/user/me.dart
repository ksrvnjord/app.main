import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql/client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ksrvnjord_main_app/providers/authentication.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';
import 'package:ksrvnjord_main_app/queries/mutations/me.dart' as mutation;
import 'package:ksrvnjord_main_app/queries/queries/me.dart' as query;
import 'package:ksrvnjord_main_app/widgets/me/visibility/change_visibility_succes_dialog.dart';
import 'package:ksrvnjord_main_app/widgets/me/visibility/show_change_visibility_dialog.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_info/amendable_user_row.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_info/static_user_field.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_avatar.dart';
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';

import '../../../widgets/me/visibility/show_change_visibility_dialog.dart';

double betweenFields = 20;
double marginContainer = 5;
double paddingBody = 15;

class MePage extends HookConsumerWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final QueryOptions options = QueryOptions(document: gql(query.meQuery));
    final Future<QueryResult> result = client.query(options);

    return Scaffold(
        appBar: AppBar(
            title: const Text('Jouw Njord-Account'),
            actions: [
              PopupMenuButton(
                position: PopupMenuPosition.under,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    onTap: () async {
                      bool mutationSucces =
                          await showChangeVisibilityDialog(context);
                      changeVisibilitySuccesDialog(context, mutationSucces);
                    },
                    child: const Center(child: Text('Zichtbaarheid Almanak')),
                  )
                ],
              )
            ],
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

                  Map<String, dynamic> shallowChanges =
                      user['fullContact']['update'];
                  Map<String, dynamic> deepChanges = Map.from(shallowChanges);
                  deepChanges.remove('__typename');

                  return MeWidget(user, deepChanges);
              }
            }));
  }
}

class MeWidget extends StatefulHookConsumerWidget {
  MeWidget(this.user, this.contactChanges, {Key? key}) : super(key: key);
  final dynamic user;
  Map<String, dynamic> contactChanges;

  @override
  _MeWidgetState createState() => _MeWidgetState();
}

class _MeWidgetState extends ConsumerState<MeWidget> {
  bool anyChanges = false;

  callBack(String label, String value) {
    setState(() {
      widget.contactChanges[label] = value;
      if ((widget.user['fullContact']['update'][label] != value) &
          !((widget.user['fullContact']['update'][label] == null) &
              (value == '-'))) {
        anyChanges = true;
      }
    });
  }

  void _reset() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const MePage(),
      ),
    );
  }

  Future<QueryResult> _sendInfoToHeimdall(contact) async {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final MutationOptions options =
        MutationOptions(document: gql(mutation.meMutation), variables: contact);
    final QueryResult result = await client.mutate(options);
    return (result);
  }

  @override
  Widget build(BuildContext context) {
    final double rowWidth = MediaQuery.of(context).size.width - 2 * paddingBody;
    List<List<Map<String, dynamic>>> amendableFieldLabels = [
      [
        {'backend': 'first_name', 'display': 'Voornaam'},
        {'backend': 'last_name', 'display': 'Achternaam'}
      ],
      [
        {'backend': 'email', 'display': 'E-mailadres'}
      ],
      [
        {'backend': 'street', 'display': 'Straatnaam'},
        {'backend': 'housenumber', 'display': 'Huisnr'},
        {'backend': 'housenumber_addition', 'display': 'Toevoeging'}
      ],
      [
        {'backend': 'zipcode', 'display': 'Postcode'},
        {'backend': 'city', 'display': 'Stad'}
      ],
    ];
    List<List<double>> amendableFieldRelativeSizes = [
      [1 / 2, 1 / 2],
      [1],
      [3 / 7, 2 / 7, 2 / 7],
      [1 / 2, 1 / 2]
    ];

    return ListView(padding: EdgeInsets.all(paddingBody), children: <Widget>[
      const Center(child: UserAvatar()),
      const SizedBox(height: 10),
      const SizedBox(height: 20),
      StaticUserField('Lidnummer', widget.user['identifier'].toString()),
      StaticUserField('Njord-account', widget.user['username'] ?? '-'),
      SizedBox(
          height: 190,
          width: rowWidth,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: amendableFieldLabels.length,
              itemBuilder: (BuildContext context, int index) {
                return (Column(mainAxisSize: MainAxisSize.min, children: [
                  AmendableUserRow(
                      widget.user,
                      widget.contactChanges,
                      amendableFieldLabels[index],
                      amendableFieldRelativeSizes[index],
                      rowWidth,
                      callBack),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  )
                ]));
              })),
      const Text(
        '*Cursief gedrukte velden zijn reeds gewijzigd en wachtend op goedkeuring.',
        style: TextStyle(fontSize: 11),
      ),
      const Divider(
        height: 32,
      ),
      if (anyChanges == true) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Wijzigingen opslaan',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                QueryResult queryResult = await _sendInfoToHeimdall(
                    {'contact': widget.contactChanges});
                bool querySucces = queryResult.data?['__typename'] != null;
                verificationDialog(context, querySucces);
                if (querySucces) {
                  _reset();
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Wijzigingen ongedaan maken',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                setState(() {
                  _reset();
                });
              },
            ),
          ],
        )
      ],
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
