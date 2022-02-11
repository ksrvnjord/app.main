import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/widgets/me/group_container.dart';

class GroupGrid extends StatelessWidget {
  const GroupGrid(this.values, {Key? key}) : super(key: key);

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 5,
            childAspectRatio: 7.1),
        scrollDirection: Axis.vertical,
        itemCount: values.length,
        padding: const EdgeInsets.all(5),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, idx) {
          return GroupContainer(values[idx]);
        });
  }
}
