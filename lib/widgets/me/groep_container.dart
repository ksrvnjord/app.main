import 'package:flutter/material.dart';

class GroupContainer extends StatelessWidget {
  const GroupContainer(this.value, {Key? key}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(value),
        padding: const EdgeInsets.all(3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(4),
        ));
  }
}
