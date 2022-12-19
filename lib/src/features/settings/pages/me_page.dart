import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/schema.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/models/me.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
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
                      Routemaster.of(context).push('/settings/privacy');
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

Map<String, Object?> createInitialField({
  required double width,
  required String label,
  required String initialValue,
  required String? updatedValue,
}) {
  return {
    'changed': false,
    'width': width,
    'controller': TextEditingController(text: initialValue),
    'display': label,
    'initial': initialValue,
    'updated': updatedValue,
  };
}

class _MeWidgetState extends State<MeWidget> {
  List<Map<String, Map<String, dynamic>>> fields = [];
  bool saving = false;
  Color buttonColor = Colors.blue;

  @override
  void initState() {
    final contact = widget.user?.fullContact.private;
    final updated = widget.user?.fullContact.update;

    fields = [
      {
        'first_name': createInitialField(
            width: 1 / 2,
            label: 'Voornaam',
            initialValue: contact!.first_name!,
            updatedValue: updated?.first_name),
        'last_name': createInitialField(
            width: 1 / 2,
            label: 'Achternaam',
            initialValue: contact.last_name!,
            updatedValue: updated?.last_name),
      },
      {
        'email': 
            createInitialField(
                width: 1,
                label: 'E-mailadres',
                initialValue: contact.email!,
                updatedValue: updated?.email),
      },
      {
        'phone_primary': 
            createInitialField(
                width: 1,
                label: 'Telefoonnummer',
                initialValue: contact.phone_primary!,
                updatedValue: updated?.phone_primary),
      },
      {
        'street': 
            createInitialField(
                width: 4/6,
                label: 'Straat',
                initialValue: contact.street!,
                updatedValue: updated?.street),
        'housenumber': 
            createInitialField(
                width: 1/6,
                label: 'Huisnummer',
                initialValue: contact.housenumber!,
                updatedValue: updated?.housenumber),
        'housenumber_addition': 
            createInitialField(
                width: 1/6,
                label: 'Toevoeging',
                initialValue: contact.housenumber_addition!,
                updatedValue: updated?.housenumber_addition),
      },
      {
        'zipcode': 
            createInitialField(
                width: 1/3,
                label: 'Postcode',
                initialValue: contact.zipcode!,
                updatedValue: updated?.zipcode),
        'city': 
            createInitialField(
                width: 2/3,
                label: 'Plaats',
                initialValue: contact.city!,
                updatedValue: updated?.city),
      }
    ];
    super.initState();
  }

  TextStyle labelTextStyle(dynamic label) {
    if (label['changed']) {
      return const TextStyle(color: Colors.blueAccent);
    }

    if (label['updated'] != null) {
      return const TextStyle(color: Colors.blueGrey);
    }

    return const TextStyle();
  }

  @override
  Widget build(BuildContext context) {
    final double rowWidth = MediaQuery.of(context).size.width - 2 * paddingBody;
    final client = Provider.of<GraphQLModel>(context).client;

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
      ...fields.asMap().entries.map<Widget>((i) {
        int idx = i.key;
        final row = i.value;

        return row.keys
            .map<Widget>((key) {
              dynamic label = row[key];

              return SizedBox(
                  width: label['width'] * rowWidth,
                  child: Builder(builder: (_) {
                    return TextFormField(
                        style: labelTextStyle(label),
                        decoration: InputDecoration(
                          labelText: label['display'] ?? '',
                          labelStyle: labelTextStyle(label),
                        ),
                        controller: label['controller'],
                        onChanged: (value) {
                          setState(() {
                            fields[idx][key]?['changed'] =
                                (label['initial'] != label['controller'].text);
                          });
                        }).padding(all: 5);
                  }));
            })
            .toList()
            .toRow();
      }).toList(),
      ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              onPressed: () {
                setState(() {
                  saving = true;
                  buttonColor = Colors.blueGrey;
                });
                updateMe(
                    client,
                    Input$IContact(
                      first_name: fields[0]['first_name']?['controller'].text,
                      last_name: fields[0]['last_name']?['controller'].text,
                      email: fields[1]['email']?['controller'].text,
                      phone_primary:
                          fields[2]['phone_primary']?['controller'].text,
                      street: fields[3]['street']?['controller'].text,
                      housenumber: fields[3]['housenumber']?['controller'].text,
                      housenumber_addition:
                          fields[3]['housenumber_addition']?['controller'].text,
                      zipcode: fields[3]['zipcode']?['controller'].text,
                      city: fields[3]['city']?['controller'].text,
                    )).then((data) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Updateverzoek verstuurd')));
                  setState(() {
                    saving = false;
                    buttonColor = Colors.blue;
                  });
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content:
                          Text('Updateverzoek mislukt, melding gemaakt.')));
                  setState(() {
                    saving = false;
                    buttonColor = Colors.red;
                  });
                });
              },
              child: saving
                  ? const SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(color: Colors.white))
                      .center()
                      .padding(all: 10)
                  : const Text('Opslaan'))
          .padding(all: 5),
      const Text(
          '* Grijs gedrukte velden zijn reeds gewijzigd en wachtend op goedkeuring.',
          style: TextStyle(color: Colors.blueGrey, fontSize: 11)),
      const Divider(
        height: 32,
      ),
      GestureDetector(
          onTap: () {
            Provider.of<AuthModel>(context, listen: false).logout();
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                Text('Uitloggen', style: TextStyle(color: Colors.red))
              ])),
    ]);
  }
}
