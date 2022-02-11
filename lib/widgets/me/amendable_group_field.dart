import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/group_grid.dart';

class AmendableGroupField extends StatelessWidget {
  const AmendableGroupField(this.label, this.values, {Key? key})
      : super(key: key);

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          const SizedBox(height: 3),
          Row(children: [
            Container(width: 300, child: GroupGrid(values)),
            const Spacer(),
            IconButton(
                padding: const EdgeInsets.all(0),
                iconSize: 20,
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () {}),
          ]),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ]);
  }
}
