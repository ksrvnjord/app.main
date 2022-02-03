import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeUserinfoDialog extends StatelessWidget {
  ChangeUserinfoDialog(this.label, {Key? key}) : super(key: key);

  final String label;
  String new_value = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }
}

decide_keyboard(label) {
  if (label == 'E-mailadres' || label == 'Njord-account') {
    return (TextInputType.emailAddress);
  } else if (label == 'Telefoonnummer') {
    return (TextInputType.phone);
  }
}
