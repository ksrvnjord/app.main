import 'package:flutter/material.dart';

class DataTextListTile extends StatelessWidget {
  const DataTextListTile({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 20,
        ),
      ),
    );
  }
}
