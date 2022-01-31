import 'package:flutter/material.dart';

class StaticUserField extends StatelessWidget {
  const StaticUserField(this.label, this.value, {Key? key}) : super(key: key);

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
            content: TextField(onChanged: (text) {
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
                          // Update_User(label, new_value)
                          Navigator.pop(context, true);
                        }
                      }),
                ],
              )
            ],
          )));
}

Show_change_confirmation(context) {
  const String confirm_text =
      '''Gegevensverandering was succesvol!\nAangezien elke verandering door het bestuur moet worden goedgekeurd, kan het even duren voordat de verandering daadwerkelijk zichtbaar is.''';

  return (showDialog(
      barrierDismissible: false,
      barrierColor: null,
      context: context,
      builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.green,
          alignment: Alignment.bottomCenter,
          insetPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(0),
                  child: IconButton(
                      padding: const EdgeInsets.only(bottom: 5),
                      constraints: BoxConstraints.tight(const Size(20, 20)),
                      iconSize: 20,
                      icon:
                          const Icon(Icons.close_rounded, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      })),
              const Text(confirm_text, textAlign: TextAlign.center)
            ],
          ))));
}
