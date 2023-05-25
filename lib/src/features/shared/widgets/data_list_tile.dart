import 'package:flutter/material.dart';

// This is a generic list tile for displaying data.
class DataListTile extends StatelessWidget {
  const DataListTile({
    Key? key,
    required this.icon,
    required this.data,
  }) : super(key: key);

  final Icon icon;
  final String data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(data),
    );
  }
}
