import 'dart:ffi';

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
  List<List<Map<String, dynamic>>> amendableFieldLabels = [];

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
  void initState() {
    final contact = widget.user?.fullContact.private;
    final updated = widget.user?.fullContact.update;

    amendableFieldLabels = [
      [
        {
          'changed': false,
          'width': 1 / 2,
          'controller': TextEditingController(text: contact?.first_name),
          'backend': 'first_name',
          'display': 'Voornaam',
          'initial': contact?.first_name,
          'updated': updated?.first_name,
        },
        {
          'changed': false,
          'width': 1 / 2,
          'controller': TextEditingController(text: contact?.last_name),
          'backend': 'last_name',
          'display': 'Achternaam',
          'initial': contact?.last_name,
          'updated': updated?.last_name,
        }
      ],
      [
        {
          'changed': false,
          'width': 1,
          'controller': TextEditingController(text: contact?.email),
          'backend': 'email',
          'display': 'E-mailadres',
          'initial': contact?.email,
          'updated': updated?.email,
        }
      ],
      [
        {
          'changed': false,
          'width': 1,
          'controller': TextEditingController(text: contact?.phone_primary),
          'backend': 'phone_primary',
          'display': 'Telefoonnummer',
          'initial': contact?.phone_primary,
          'updated': updated?.phone_primary,
        }
      ],
      [
        {
          'changed': false,
          'width': 4 / 6,
          'controller': TextEditingController(text: contact?.street),
          'backend': 'street',
          'display': 'Straatnaam',
          'initial': contact?.street,
          'updated': updated?.street,
        },
        {
          'changed': false,
          'width': 1 / 6,
          'controller': TextEditingController(text: contact?.housenumber),
          'backend': 'housenumber',
          'display': 'Huisnr',
          'initial': contact?.housenumber,
          'updated': updated?.housenumber,
        },
        {
          'changed': false,
          'width': 1 / 6,
          'controller':
              TextEditingController(text: contact?.housenumber_addition),
          'backend': 'housenumber_addition',
          'display': 'Toevoeging',
          'initial': contact?.housenumber_addition,
          'updated': updated?.housenumber_addition,
        }
      ],
      [
        {
          'changed': false,
          'width': 1 / 2,
          'controller': TextEditingController(text: contact?.zipcode),
          'backend': 'zipcode',
          'display': 'Postcode',
          'initial': contact?.zipcode,
          'updated': updated?.zipcode,
        },
        {
          'changed': false,
          'width': 1 / 2,
          'controller': TextEditingController(text: contact?.city),
          'backend': 'city',
          'display': 'Stad',
          'initial': contact?.city,
          'updated': updated?.city,
        }
      ],
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double rowWidth = MediaQuery.of(context).size.width - 2 * paddingBody;

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
              var textStyle = const TextStyle();

              if (label['changed']) {
                textStyle = const TextStyle(color: Colors.blueAccent);
              }

              if (label['updated'] != null) {
                textStyle = const TextStyle(fontWeight: FontWeight.w400);
              }

              if (label['changed'] && label['updated'] != null) {
                textStyle = const TextStyle(
                    fontWeight: FontWeight.w400, color: Colors.blueAccent);
              }

              return SizedBox(
                  width: label['width'] * rowWidth,
                  child: Builder(builder: (_) {
                    return TextFormField(
                        style: textStyle,
                        decoration: InputDecoration(
                          labelText: label['display'] ?? '',
                          labelStyle: textStyle,
                        ),
                        controller: label['controller'],
                        onChanged: (value) {
                          label['changed'] =
                              (label['initial'] != label['controller'].text);
                          setState(() {});
                        }).padding(all: 5);
                  }));
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
