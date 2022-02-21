import 'package:flutter/material.dart';

class StaticUserField extends StatelessWidget {
  const StaticUserField(this.label, this.value, {Key? key}) : super(key: key);

  final String label;
  final String value;

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
          Text(value),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ]);
  }
}
