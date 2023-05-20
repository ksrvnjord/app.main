// ignore_for_file: prefer-single-widget-per-file
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';
import 'package:ksrvnjord_main_app/schema.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.graphql.dart';
import 'package:ksrvnjord_main_app/src/features/settings/api/me.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

class MePage extends ConsumerWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(graphQLModelProvider).client;
    var result = me(client);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Jouw Njord-Account'),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
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

class _MeWidgetState extends ConsumerState<MeWidget> {
  List<Map<String, Map<String, dynamic>>> fields = [];
  bool saving = false;
  Color buttonColor = Colors.blue;

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
          initialValue: contact?.first_name ?? '',
          updatedValue: updated?.first_name,
        ),
        'last_name': createInitialField(
          // ignore: no-magic-number
          width: 1 / 2,
          label: 'Achternaam',
          initialValue: contact?.last_name ?? '',
          updatedValue: updated?.last_name,
        ),
      },
      {
        'email': createInitialField(
          width: 1,
          label: 'E-mailadres',
          initialValue: contact?.email ?? '',
          updatedValue: updated?.email,
        ),
      },
      {
        'phone_primary': createInitialField(
          width: 1,
          label: 'Telefoonnummer',
          initialValue: contact?.phone_primary ?? '',
          updatedValue: updated?.phone_primary,
        ),
      },
      {
        'street': createInitialField(
          // ignore: no-magic-number
          width: 2 / 4,
          label: 'Straat',
          initialValue: contact?.street ?? '',
          updatedValue: updated?.street,
        ),
        'housenumber': createInitialField(
          // ignore: no-magic-number
          width: 1 / 4,
          label: 'Huisnummer',
          initialValue: contact?.housenumber ?? '',
          updatedValue: updated?.housenumber,
        ),
        'housenumber_addition': createInitialField(
          // ignore: no-magic-number
          width: 1 / 4,
          label: 'Toevoeging',
          initialValue: contact?.housenumber_addition ?? '',
          updatedValue: updated?.housenumber_addition,
        ),
      },
      {
        'zipcode': createInitialField(
          // ignore: no-magic-number
          width: 1 / 3,
          label: 'Postcode',
          initialValue: contact?.zipcode ?? '',
          updatedValue: updated?.zipcode,
        ),
        'city': createInitialField(
          // ignore: no-magic-number
          width: 2 / 3,
          label: 'Plaats',
          initialValue: contact?.city ?? '',
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
    const double paddingBody = 15;
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
          initialValue: widget.user.identifier,
          decoration: const InputDecoration(labelText: 'Lidnummer'),
          enabled: false,
        ).padding(all: fieldPadding),
        TextFormField(
          initialValue: widget.user.username,
          decoration: const InputDecoration(labelText: 'Njord-account'),
          enabled: false,
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
                      controller: label['controller'],
                      decoration: InputDecoration(
                        labelText: label['display'] ?? '',
                        labelStyle: labelTextStyle(label),
                      ),
                      style: labelTextStyle(label),
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
          onPressed: () => save(context, client),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          child: saving
              ? const SizedBox(
                  width: 10,
                  height: 10,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.logout, color: Colors.red),
              Text('Uitloggen', style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: () => ref.read(authModelProvider).logout(),
        ),
      ],
    );
  }

  void save(BuildContext context, GraphQLClient client) async {
    setState(() {
      saving = true;
      buttonColor = Colors.blueGrey;
    });
    try {
      // ignore: avoid-ignoring-return-values
      await updateMe(
        client,
        Input$IContact(
          first_name: fields.first['first_name']?['controller'].text,
          last_name: fields.first['last_name']?['controller'].text,
          zipcode: fields[3]['zipcode']?['controller'].text,
          street: fields[3]['street']?['controller'].text,
          housenumber: fields[3]['housenumber']?['controller'].text,
          housenumber_addition:
              fields[3]['housenumber_addition']?['controller'].text,
          city: fields[3]['city']?['controller'].text,
          email: fields[1]['email']?['controller'].text,
          phone_primary: fields[2]['phone_primary']?['controller'].text,
        ),
      );
      // ignore: avoid-ignoring-return-values, use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updateverzoek verstuurd')),
      );
      if (mounted) {
        setState(() {
          saving = false;
          buttonColor = Colors.blue;
        });
      }
    } catch (e) {
      // ignore: avoid-ignoring-return-values
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Updateverzoek mislukt, melding gemaakt.'),
        backgroundColor: Colors.red,
      ));
      if (mounted) {
        setState(() {
          saving = false;
          buttonColor = Colors.red;
        });
      }
    }
  }
}
