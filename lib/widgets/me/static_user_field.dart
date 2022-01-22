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
          onPressed: () {
            Change_Field(context, label);
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
            content: TextField(onSubmitted: (text) {
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
                        Navigator.of(context).pop();
                      }),
                  IconButton(
                      padding: const EdgeInsets.all(8),
                      iconSize: 30,
                      icon: const Icon(Icons.done_rounded, color: Colors.green),
                      onPressed: () {
                        if (new_value == '') {
                          Navigator.pop(context);
                        } else {
                          // Update_User(label, new_value)
                          Navigator.pop(context);
                        }
                      }),
                ],
              )
            ],
          )));
}

Confirm_Change() {}
