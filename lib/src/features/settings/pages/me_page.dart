import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/models/me.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

double betweenFields = 20;
double marginContainer = 5;
double paddingBody = 15;

class MePage extends StatelessWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<GraphQLModel>(context).client;
    final result = me(client);

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
                      // bool mutationSucces =
                      //     await showChangeVisibilityDialog(context);
                      // changeVisibilitySuccesDialog(context, mutationSucces);
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
        body: FutureWrapper(
            future: result,
            success: (me) {
              return MeWidget(me);
            }));
  }
}

class MeWidget extends StatefulWidget {
  const MeWidget(this.user, {Key? key}) : super(key: key);
  final Query$Me$me? user;

  @override
  createState() => _MeWidgetState();
}

class _MeWidgetState extends State<MeWidget> {
  bool anyChanges = false;

  // callBack(String label, String value) {
  //   setState(() {
  //     widget.contactChanges[label] = value;
  //     if ((widget.user['fullContact']['update'][label] != value) &
  //         !((widget.user['fullContact']['update'][label] == null) &
  //             (value == '-'))) {
  //       anyChanges = true;
  //     }
  //   });
  // }

  // void _reset() {
  //   Navigator.pushReplacement(
  //     context,
  //     PageRouteBuilder(
  //       transitionDuration: Duration.zero,
  //       pageBuilder: (_, __, ___) => const MePage(),
  //     ),
  //   );
  // }

  // Future<QueryResult> _sendInfoToHeimdall(contact) async {
  //   final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
  //   final MutationOptions options =
  //       MutationOptions(document: gql(mutation.meMutation), variables: contact);
  //   final QueryResult result = await client.mutate(options);
  //   return (result);
  // }

  @override
  Widget build(BuildContext context) {
    final contact = widget.user?.fullContact.private;
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
        {'backend': 'phone_primary', 'display': 'Telefoonnummer'}
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
      [1],
      [3 / 7, 2 / 7, 2 / 7],
      [1 / 2, 1 / 2]
    ];

    return ListView(padding: EdgeInsets.all(paddingBody), children: <Widget>[
      Center(child: Container()),
      const SizedBox(height: 10),
      const SizedBox(height: 20),
      TextFormField(
              decoration: const InputDecoration(labelText: 'Lidnummer'),
              enabled: false,
              initialValue: '${widget.user?.identifier}')
          .padding(all: 5),
      TextFormField(
              decoration: const InputDecoration(labelText: 'Njord-account'),
              enabled: false,
              initialValue: '${widget.user?.username}')
          .padding(all: 5),
      ...amendableFieldLabels.map<Widget>((labels) {
        return labels
            .map<Widget>((label) {
              return TextFormField(
                      decoration:
                          InputDecoration(labelText: label['display'] ?? ''),
                      initialValue: contact?.toJson()[label['backend']])
                  .padding(all: 5)
                  .expanded();
            })
            .toList()
            .toRow();
      }).toList(),
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
                // ref.read(authenticationProvider).logout();
              },
            ),
            const Text('Uitloggen', style: TextStyle(color: Colors.red))
          ])
    ]);
  }
}
