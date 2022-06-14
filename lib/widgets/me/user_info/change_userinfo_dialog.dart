import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ksrvnjord_main_app/providers/heimdall.dart';

class ChangeUserinfoDialog extends StatefulHookConsumerWidget {
  final String label;

  const ChangeUserinfoDialog({Key? key, required this.label}) : super(key: key);

  @override
  _ChangeUserinfoDialogState createState() => _ChangeUserinfoDialogState();
}

class _ChangeUserinfoDialogState extends ConsumerState<ChangeUserinfoDialog> {
  String newValue = '';

  Map transform_label = {
    'Voornaam': 'first_name',
    'Achternaam': 'last_name',
    'E-mailadres': 'email',
    'Straat': 'street',
    'Huisnummer': 'housenumber',
    'Toevoeging': 'housenumber_addition',
    'Postcode': 'zipcode',
    'Stad': 'city'
  };

  TextInputType decideKeyboard(label) {
    if (label == 'E-mailadres' || label == 'Njord-account') {
      return (TextInputType.emailAddress);
    } else if (label == 'Telefoonnummer') {
      return (TextInputType.phone);
    } else {
      return (TextInputType.text);
    }
  }

  update_user(label, newValue) async {
    String backend_label = transform_label[label];
    String me_mutation = '''
      mutation (\$contact: IContact!){
        updateContactDetails(contact: \$contact) {
          $backend_label
        }
      }
      ''';
    Map<String, dynamic> contact = {
      "contact": {backend_label: newValue}
    };

    final GraphQLClient client = ref.watch(heimdallProvider).graphQLClient();
    final MutationOptions options =
        MutationOptions(document: gql(me_mutation), variables: contact);
    final QueryResult result = await client.mutate(options);

    if (result.data != null) {
      if (result.data!['updateContactDetails'][backend_label] == newValue) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Verander je ${widget.label}')),
      content: TextField(
          autofocus: true,
          keyboardType: decideKeyboard(widget.label),
          onChanged: (text) {
            newValue = text;
          }),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                padding: const EdgeInsets.all(8),
                iconSize: 30,
                icon: const Icon(Icons.close_rounded, color: Colors.red),
                onPressed: () {
                  Navigator.pop(context, false);
                }),
            IconButton(
                padding: const EdgeInsets.all(8),
                iconSize: 30,
                icon: const Icon(Icons.done_rounded, color: Colors.green),
                onPressed: () async {
                  if (newValue == '') {
                    Navigator.pop(context, false);
                  } else {
                    bool succes = await update_user(widget.label, newValue);
                    Navigator.pop(context, succes);
                  }
                }),
          ],
        )
      ],
    );
  }
}
