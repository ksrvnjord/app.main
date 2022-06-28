import 'package:flutter/material.dart';

void showChangeVisibilityDialog(context) {
  showDialog(
      barrierDismissible: true,
      barrierColor: null,
      context: context,
      builder: (BuildContext context) => const ChangeVisibilityDialog());
}

class ChangeVisibilityDialog extends StatefulWidget {
  const ChangeVisibilityDialog({Key? key}) : super(key: key);

  @override
  _ChangeVisibilityDialogState createState() => _ChangeVisibilityDialogState();
}

class _ChangeVisibilityDialogState extends State<ChangeVisibilityDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      title: const Text('Aanpassen zichtbaarheid almanak'),
      content: Column(children: [
        const Text(
            '''Geef hier aan welke gegevens zichtbaar zijn in de almanak voor andere leden.'''),
      ]),
      actions: [
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          child: const Text(
            'Wijzigingen ongedaan maken',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.green),
          child: const Text(
            'Wijzigingen opslaan',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
