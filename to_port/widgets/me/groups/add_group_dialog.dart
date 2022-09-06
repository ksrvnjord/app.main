import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/groups/group_searchbar.dart';

// THIS WIDGET EVENTUALLY HAS TO QUERY THE DATABASE FOR ALL GROUPS!!!!!!!!!!!!

class AddGroupDialog extends StatefulWidget {
  final String label;
  final List<dynamic> values;
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
      content: SizedBox(
          height: 140,
          width: 250,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(bottom: 20, left: 40, right: 40),
                width: 225,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(width: 2, color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                    onPressed: () async {
                      String searchResult = await showSearch(
                        context: context,
                        delegate:
                            CustomSearchDelegate(widget.groepen[widget.label]),
                      );
                      setState(() {
                        newGroup = searchResult;
                      });
                    },
                    child: Row(children: [
                      const Text('Search...',
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      const Spacer(),
                      Icon(Icons.search, color: Colors.grey.shade800)
                    ]))),
            const Text('Door jou gekozen groep:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            Center(
                child: (newGroup == '')
                    ? const Text('Geen groep gekozen')
                    : Text(newGroup))
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
