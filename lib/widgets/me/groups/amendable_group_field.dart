import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/groups/group_grid.dart';
import 'package:ksrvnjord_main_app/widgets/me/groups/group_icon.dart';

class AmendableGroupField extends StatelessWidget {
  const AmendableGroupField(this.label, this.values, {Key? key})
      : super(key: key);

  final String label;
  final List<dynamic> values;

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
            SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: GroupGrid(values)),
          ],
        ),
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GroupIcon(label, values, false),
            const SizedBox(height: 10),
            GroupIcon(label, values, true)
          ],
        )
      ]),
      const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    ]);
  }
}
