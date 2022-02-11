import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/group_grid.dart';
import 'package:ksrvnjord_main_app/widgets/me/change_group_dialog.dart';
import 'package:ksrvnjord_main_app/widgets/me/verification_dialog.dart';

class AmendableGroupField extends StatelessWidget {
  const AmendableGroupField(this.label, this.values, {Key? key})
      : super(key: key);

  final String label;
  final List<String> values;

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
            Container(width: 325, child: GroupGrid(values)),
          ],
        ),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(),
          iconSize: 20,
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () async {
            bool succesful_change = await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    ChangeGroupinfoDialog(label: label));
            if (succesful_change == true) {
              String title = '''Verandering $label was succesvol!\n\n''';
              const String body =
                  '''Aangezien elke verandering door het bestuur moet worden goedgekeurd, kan het even duren voordat de verandering daadwerkelijk zichtbaar is.''';
              showDialog(
                  barrierDismissible: false,
                  barrierColor: null,
                  context: context,
                  builder: (BuildContext context) =>
                      VerificationDialog(title, body));
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
