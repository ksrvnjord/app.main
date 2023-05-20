import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/schema.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/models/me.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

const double betweenFields = 20;
const double marginContainer = 5;
const double paddingBody = 15;

class MePage extends ConsumerWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(graphQLModelProvider).client;
    var result = me(client);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jouw Njord-Account'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: true,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: FutureWrapper(
        future: result,
        success: (me) => me != null ? MeWidget(me) : Container(),
      ),
    );
  }
}

class MeWidget extends ConsumerStatefulWidget {
  const MeWidget(this.user, {Key? key}) : super(key: key);
  final Query$Me$me user;

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

class _MeWidgetState extends ConsumerState<MeWidget> {
  List<Map<String, Map<String, dynamic>>> fields = [];
  bool saving = false;
  Color buttonColor = Colors.blue;

  @override
  void initState() {
    var fullContact = widget.user.fullContact;
    final contact = fullContact.private;
    final updated = fullContact.update;

    // TODO: Size the fields dynamically?
    fields = [
      {
        'first_name': createInitialField(
          // ignore: no-magic-number
          width: 1 / 2,
          label: 'Voornaam',
          initialValue: contact!.first_name ?? '',
          updatedValue: updated?.first_name,
        ),
        'last_name': createInitialField(
          // ignore: no-magic-number
          width: 1 / 2,
          label: 'Achternaam',
          initialValue: contact.last_name ?? '',
          updatedValue: updated?.last_name,
        ),
      },
      {
        'email': createInitialField(
          width: 1,
          label: 'E-mailadres',
          initialValue: contact.email ?? '',
          updatedValue: updated?.email,
        ),
      },
      {
        'phone_primary': createInitialField(
          width: 1,
          label: 'Telefoonnummer',
          initialValue: contact.phone_primary ?? '',
          updatedValue: updated?.phone_primary,
        ),
      },
      {
        'street': createInitialField(
          // ignore: no-magic-number
          width: 2 / 4,
          label: 'Straat',
          initialValue: contact.street ?? '',
          updatedValue: updated?.street,
        ),
        'housenumber': createInitialField(
          // ignore: no-magic-number
          width: 1 / 4,
          label: 'Huisnummer',
          initialValue: contact.housenumber ?? '',
          updatedValue: updated?.housenumber,
        ),
        'housenumber_addition': createInitialField(
          // ignore: no-magic-number
          width: 1 / 4,
          label: 'Toevoeging',
          initialValue: contact.housenumber_addition ?? '',
          updatedValue: updated?.housenumber_addition,
        ),
      },
      {
        'zipcode': createInitialField(
          // ignore: no-magic-number
          width: 1 / 3,
          label: 'Postcode',
          initialValue: contact.zipcode ?? '',
          updatedValue: updated?.zipcode,
        ),
        'city': createInitialField(
          // ignore: no-magic-number
          width: 2 / 3,
          label: 'Plaats',
          initialValue: contact.city ?? '',
          updatedValue: updated?.city,
        ),
      },
    ];
    super.initState();
  }

  TextStyle labelTextStyle(Map<String, dynamic> label) {
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
    final double rowWidth = MediaQuery.of(context).size.width - paddingBody * 2;
    final client = ref.watch(graphQLModelProvider).client;

    const double fieldPadding = 8;

    const double saveButtonPadding = 8;
    const double onSaveButtonPadding = 8;

    return ListView(
      padding: const EdgeInsets.all(paddingBody),
      children: <Widget>[
        Center(child: Container()),
        const SizedBox(height: 10),
        const SizedBox(height: 20),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Lidnummer'),
          enabled: false,
          initialValue: widget.user.identifier,
        ).padding(all: fieldPadding),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Njord-account'),
          enabled: false,
          initialValue: widget.user.username,
        ).padding(all: fieldPadding),
        ...fields.asMap().entries.map<Widget>((i) {
          int idx = i.key;
          final Map<String, Map<String, dynamic>> row = i.value;

          return row.keys
              .map<Widget>((key) {
                Map<String, dynamic> label = row[key]!;

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
                      onChanged: (value) => setState(() {
                        fields[idx][key]?['changed'] =
                            (label['initial'] != label['controller'].text);
                      }),
                    ).padding(all: fieldPadding);
                  }),
                );
              })
              .toList()
              .toRow();
        }).toList(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          onPressed: () => save(context, client),
          child: saving
              ? const SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(color: Colors.white),
                ).center().padding(all: onSaveButtonPadding)
              : const Text('Opslaan'),
        ).padding(all: saveButtonPadding),
        const Text(
          '* Grijs gedrukte velden zijn reeds gewijzigd en wachtend op goedkeuring.',
          style: TextStyle(color: Colors.blueGrey, fontSize: 11),
        ),
        const Divider(
          height: 32,
        ),
        GestureDetector(
          onTap: () => ref.read(authModelProvider).logout(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.logout,
                color: Colors.red,
              ),
              Text('Uitloggen', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void save(BuildContext context, GraphQLClient client) {
    setState(() {
      saving = true;
      buttonColor = Colors.blueGrey;
    });
    updateMe(
      client,
      Input$IContact(
        first_name: fields.first['first_name']?['controller'].text,
        last_name: fields.first['last_name']?['controller'].text,
        email: fields[1]['email']?['controller'].text,
        phone_primary: fields[2]['phone_primary']?['controller'].text,
        street: fields[3]['street']?['controller'].text,
        housenumber: fields[3]['housenumber']?['controller'].text,
        housenumber_addition:
            fields[3]['housenumber_addition']?['controller'].text,
        zipcode: fields[3]['zipcode']?['controller'].text,
        city: fields[3]['city']?['controller'].text,
      ),
    ).then((data) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updateverzoek verstuurd')),
      );
      setState(() {
        saving = false;
        buttonColor = Colors.blue;
      });
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Updateverzoek mislukt, melding gemaakt.'),
      ));
      setState(() {
        saving = false;
        buttonColor = Colors.red;
      });
    });
  }
}
