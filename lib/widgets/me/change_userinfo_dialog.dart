import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangeUserinfoDialog extends StatefulWidget {
  final String label;

  ChangeUserinfoDialog({required this.label});

  @override
  _ChangeUserinfoDialogState createState() => _ChangeUserinfoDialogState();
}

class _ChangeUserinfoDialogState extends State<ChangeUserinfoDialog> {
  String new_value = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Verander je ${widget.label}')),
      content: TextField(
          autofocus: true,
          keyboardType: decide_keyboard(widget.label),
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
