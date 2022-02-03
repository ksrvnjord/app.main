import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';

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
            bool succesful_change = await Change_Field(context, label);
            if (succesful_change == true) {
              Show_change_confirmation(context);
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

Change_Field(context, label) {
  String new_value = '';

  return (showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Center(child: Text('Verander je $label')),
            content: TextField(
                autofocus: true,
                keyboardType: decide_keyboard(label),
                onChanged: (text) {
                  new_value = text;
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
                      onPressed: () {
                        if (new_value == '') {
                          Navigator.pop(context, false);
                        } else {
                          // Update_User(label, new_value):TODO
                          //TODO::
                          Navigator.pop(context, true);
                        }
                      }),
                ],
              )
            ],
          )));
}

decide_keyboard(label) {
  if (label == 'Naam') {
    return (TextInputType.name);
  } else if (label == 'E-mailadres' || label == 'Njord-account') {
    return (TextInputType.emailAddress);
  } else if (label == 'Lidnummer') {
    return (TextInputType.number);
  } else if (label == 'Telefoonnummer') {
    return (TextInputType.phone);
  }
}

Show_change_confirmation(context) {
  const String confirm_text1 = '''Gegevensverandering was succesvol!\n\n''';
  const String confirm_text2 =
      '''Aangezien elke verandering door het bestuur moet worden goedgekeurd, kan het even duren voordat de verandering daadwerkelijk zichtbaar is.''';

  return (showDialog(
      barrierDismissible: false,
      barrierColor: null,
      context: context,
      builder: (BuildContext context) =>
          const VerificationDialog(confirm_text1, confirm_text2)));
}
