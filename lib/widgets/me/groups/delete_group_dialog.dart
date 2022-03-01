import 'package:flutter/material.dart';

class DeleteGroupDialog extends StatefulWidget {
  final String label;
  final List<dynamic> values;

  const DeleteGroupDialog({Key? key, required this.label, required this.values})
      : super(key: key);

  @override
  _DeleteGroupDialogState createState() => _DeleteGroupDialogState();
}

class _DeleteGroupDialogState extends State<DeleteGroupDialog> {
  String SelectedValue = '';

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
              'Kies de ${decideTitle(widget.label)} die je wil verwijderen.')),
      content: Container(
          height: 80 + widget.values.length * 30,
          width: 250,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.values.length,
            itemBuilder: (context, idx) {
              return (Container(
                  color: (SelectedValue == widget.values[idx])
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.transparent,
                  child: ListTile(
                    title: Text(widget.values[idx]),
                    onTap: () {
                      setState(() {
                        if (SelectedValue == widget.values[idx]) {
                          SelectedValue = '';
                        } else {
                          SelectedValue = widget.values[idx];
                        }
                      });
                    },
                  )));
            },
          )),
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
                  if (SelectedValue == '') {
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
