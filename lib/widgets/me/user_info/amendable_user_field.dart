import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';
import 'package:ksrvnjord_main_app/widgets/me/user_info/change_userinfo_dialog.dart';
import 'package:ksrvnjord_main_app/widgets/utilities/development_feature.dart';

class AmendableUserField extends StatelessWidget {
  const AmendableUserField(this.label, this.value, {Key? key})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            const SizedBox(height: 3),
            Text(value),
          ],
        ),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(),
          iconSize: 20,
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () async {
            Map succeses = await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    ChangeUserinfoDialog(label: label));
            if (succeses['pressed_change'] == true) {
              String title = '';
              String body = '';
              Color color = Colors.red;

              if ((succeses['succesful_change'] == true)) {
                title = '''Gegevensverandering was succesvol!\n\n''';
                body =
                    '''Aangezien elke verandering door het bestuur moet worden goedgekeurd, kan het even duren voordat de verandering daadwerkelijk zichtbaar is.''';
                color = Colors.orange;
              } else {
                title = '''Gegevensverandering was NIET succesvol!\n\n''';
                body =
                    '''Er is iets misgegaan met het invullen! Weet je zeker dat je een geldige waarde hebt ingevuld?''';
              }
              showDialog(
                  barrierDismissible: false,
                  barrierColor: null,
                  context: context,
                  builder: (BuildContext context) =>
                      VerificationDialog(title, body, color));
            }
          },
        ),
      ]),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    ]);
  }
}
