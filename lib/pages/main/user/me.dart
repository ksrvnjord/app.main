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
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';
import 'package:ksrvnjord_main_app/widgets/ui/general/loading.dart';
import 'package:ksrvnjord_main_app/widgets/utilities/development_feature.dart';

double betweenFields = 20;
double marginContainer = 5;
double paddingBody = 15;

const String me = r'''
  query {
    me {
      identifier,
      email,
      username,
      fullContact {
          private{
            first_name,
            last_name
            email,
            street,
            housenumber,
            housenumber_addition,
            city,
            zipcode,
        }
        update{
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

String meMutation = '''
      mutation (\$contact: IContact!){
        updateContactDetails(contact: \$contact) {
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

                  Map<String, dynamic> shallowChanges =
                      user['fullContact']['update'];
                  Map<String, dynamic> deepChanges =
                      new Map.from(shallowChanges);
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
  bool any_changes = false;

  callBack(String label, String value) {
    setState(() {
      widget.contactChanges[label] = value;
      any_changes = true;
    });
  }

  void _reset() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => MePage(),
      ),
    );
  }

  Future<QueryResult> _sendInfoToHeimdall(contact) async {
    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final MutationOptions options =
        MutationOptions(document: gql(meMutation), variables: contact);
    final QueryResult result = await client.mutate(options);
    return (result);
  }

  @override
  Widget build(BuildContext context) {
    final dynamic contactPrivate = widget.user['fullContact']['private'];
    final dynamic contactUpdate = widget.user['fullContact']['update'];

    final double fieldWidth =
        MediaQuery.of(context).size.width - 2 * paddingBody;
    const double rowSpacing = 8;

    return ListView(padding: EdgeInsets.all(paddingBody), children: <Widget>[
      const Center(child: UserAvatar()),
      const SizedBox(height: 10),
      const SizedBox(height: 20),
      if (any_changes == true) ...[
        Row(
          children: [
            const Text('Wijzigingen (blauw) opslaan?'),
            TextButton(
              child: const Text('Opslaan'),
              onPressed: () async {
                QueryResult queryResult = await _sendInfoToHeimdall(
                    {'contact': widget.contactChanges});
                Map verificationSettings = {};
                bool query_succes = queryResult.data?['__typename'] != null;
                if (query_succes == false) {
                  verificationSettings['title'] = 'Aanvraag Mislukt!\n\n';
                  verificationSettings['body'] =
                      '''Weet je zeker dat je in elk gewijzigd veld (blauw)
                    een geldige waarde hebt opgegeven?''';
                  verificationSettings['color'] = Colors.red;
                } else {
                  verificationSettings['title'] = 'Aanvraag Geslaagd!\n\n';
                  verificationSettings['body'] =
                      '''Het even duren voordat ze in de almanak
                  zichtbaar zijn!''';
                  verificationSettings['color'] = Colors.green;
                }
                showDialog(
                    barrierDismissible: true,
                    barrierColor: null,
                    context: context,
                    builder: (BuildContext context) =>
                        VerificationDialog(verificationSettings));
                if (query_succes) {
                  _reset();
                }
              },
            ),
            TextButton(
              child: const Text('Verwijderen'),
              onPressed: () {
                setState(() {
                  _reset();
                });
              },
            ),
          ],
        )
      ],
      StaticUserField('Lidnummer', widget.user['identifier'].toString()),
      StaticUserField('Njord-account', widget.user['username'] ?? '-'),
      Row(
        children: [
          Container(
            width: fieldWidth / 2 - 30,
            padding: const EdgeInsets.only(right: rowSpacing),
            child: AmendableUserField(const {
              'backend': 'first_name',
              'display': 'Voornaam'
            }, {
              'private': contactPrivate['first_name'],
              'update': contactUpdate['first_name'],
              'change': widget.contactChanges['first_name']
            }, fieldWidth / 2, callBack),
          ),
          Container(
            width: fieldWidth / 2 - 30,
            padding: const EdgeInsets.only(left: rowSpacing),
            child: AmendableUserField(const {
              'backend': 'last_name',
              'display': 'Achternaam'
            }, {
              'private': contactPrivate['last_name'],
              'update': contactUpdate['last_name'],
              'change': widget.contactChanges['last_name']
            }, fieldWidth / 2, callBack),
          ),
        ],
      ),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
      AmendableUserField(const {
        'backend': 'email',
        'display': 'E-mailadres'
      }, {
        'private': contactPrivate['email'],
        'update': contactUpdate['email'],
        'change': widget.contactChanges['email']
      }, fieldWidth / 2, callBack),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
      Row(
        children: [
          Container(
            width: fieldWidth / 3 + 20,
            padding: const EdgeInsets.only(right: rowSpacing),
            child: AmendableUserField(const {
              'backend': 'street',
              'display': 'Straatnaam'
            }, {
              'private': contactPrivate['street'],
              'update': contactUpdate['street'],
              'change': widget.contactChanges['street']
            }, fieldWidth / 2, callBack),
          ),
          Container(
            width: fieldWidth / 3,
            padding: const EdgeInsets.only(left: rowSpacing, right: 5),
            child: AmendableUserField(const {
              'backend': 'housenumber',
              'display': 'Huisnmr'
            }, {
              'private': contactPrivate['housenumber'],
              'update': contactUpdate['housenumber'],
              'change': widget.contactChanges['housenumber']
            }, fieldWidth / 2, callBack),
          ),
          Container(
            width: fieldWidth / 3,
            padding: const EdgeInsets.only(left: 5),
            child: AmendableUserField(const {
              'backend': 'housenumber_addition',
              'display': 'Toevoeging'
            }, {
              'private': contactPrivate['housenumber_addition'],
              'update': contactUpdate['housenumber_addition'],
              'change': widget.contactChanges['housenumber_addition']
            }, fieldWidth / 2, callBack),
          ),
        ],
      ),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
      Row(
        children: [
          Container(
            width: fieldWidth / 2 - 30,
            padding: const EdgeInsets.only(right: rowSpacing),
            child: AmendableUserField(const {
              'backend': 'zipcode',
              'display': 'Postcode'
            }, {
              'private': contactPrivate['zipcode'],
              'update': contactUpdate['zipcode'],
              'change': widget.contactChanges['zipcode']
            }, fieldWidth / 2, callBack),
          ),
          Container(
            width: fieldWidth / 2 - 30,
            padding: const EdgeInsets.only(left: rowSpacing),
            child: AmendableUserField(const {
              'backend': 'city',
              'display': 'Stad'
            }, {
              'private': contactPrivate['city'],
              'update': contactUpdate['city'],
              'change': widget.contactChanges['city']
            }, fieldWidth / 2, callBack),
          ),
        ],
      ),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
      const Text(
        '*Cursief gedrukte velden zijn reeds gewijzigd en wachtend op goedkeuring.',
        style: TextStyle(fontSize: 11),
      ),
      const Divider(
        height: 32,
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
