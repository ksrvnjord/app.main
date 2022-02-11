import 'package:flutter/material.dart';

class ChangeGroupinfoDialog extends StatefulWidget {
  final String label;

  const ChangeGroupinfoDialog({Key? key, required this.label})
      : super(key: key);

  @override
  _ChangeGroupinfoDialogState createState() => _ChangeGroupinfoDialogState();
}

class _ChangeGroupinfoDialogState extends State<ChangeGroupinfoDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Aanpassen ${widget.label}')),
      //content:
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
                  //Update_user
                  Navigator.pop(context, true);
                })
          ],
        )
      ],
    );
  }
}
