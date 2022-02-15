import 'package:flutter/material.dart';

class ChangeUserinfoDialog extends StatefulWidget {
  final String label;

  const ChangeUserinfoDialog({Key? key, required this.label}) : super(key: key);

  @override
  _ChangeUserinfoDialogState createState() => _ChangeUserinfoDialogState();
}

class _ChangeUserinfoDialogState extends State<ChangeUserinfoDialog> {
  String newValue = '';

  TextInputType decideKeyboard(label) {
    if (label == 'E-mailadres' || label == 'Njord-account') {
      return (TextInputType.emailAddress);
    } else if (label == 'Telefoonnummer') {
      return (TextInputType.phone);
    } else {
      return (TextInputType.text);
    }
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
                onPressed: () {
                  if (newValue == '') {
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
