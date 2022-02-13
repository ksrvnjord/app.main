import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/group_searchbar.dart';

// THIS WIDGET EVENTUALLY HAS TO QUERY THE DATABASE FOR ALL GROUPS!!!!!!!!!!!!

class AddGroupDialog extends StatefulWidget {
  final String label;
  final List<String> values;
  Map groepen = {
    'Commissies': [
      'Competitiecomissie',
      'Appcommissie',
      'Buffetcommissie',
      'Kookcommissie',
      'Pascommissie',
      'Afroeicommissie',
      'Voorjaarscommissie',
      'Skicommissie',
      'Njord Goes Green',
      'Sjacie',
      'Carrieredagen',
    ],
    'Ploegen': [
      'EJD',
      'EJZ',
      'TopC4',
      'DTOPC4',
      'MGD',
      'EJLD',
      'Vaskir',
      'Diabolo',
      'Forte'
    ],
    'Verticalen': [
      'Vanir',
      'Heeren XII',
      'Dames 6',
      'Heeren I',
      'Verdandi',
      'Walkuren',
      'Dames 10',
      'Heeren 5'
    ]
  };

  AddGroupDialog({Key? key, required this.label, required this.values})
      : super(key: key);

  @override
  _AddGroupDialogState createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  String newGroup = '';

  String decideTitle(label) {
    if (label == 'Comissies') {
      return ('commissie');
    } else if (label == 'Ploegen') {
      return ('ploeg');
    } else {
      return ('verticaal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(
              'Kies de ${decideTitle(widget.label)} die je wil toevoegen.')),
      content: Container(
          height: 80 + widget.values.length * 30,
          width: 250,
          child: Column(children: [
            TextButton(
                child: const Text('Search...'),
                onPressed: () {
                  newGroup = showSearch(
                    context: context,
                    delegate:
                        CustomSearchDelegate(widget.groepen[widget.label]),
                  ) as String;
                }),
            Text('Toe te voegen groep: $newGroup'),
          ])),
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
                  if (newGroup == '') {
                    Navigator.pop(context, false);
                  } else {
                    // Voeg groep toe(label, newGroup):TODO
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
