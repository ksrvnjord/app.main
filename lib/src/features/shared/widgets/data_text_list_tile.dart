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
    // TODO: dont use ListTile as it automatically expands to the full screenwidth.
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      title: Text(
        name,
        style: textTheme.labelLarge,
      ),
      subtitle: Text(
        value,
        style: textTheme.titleLarge,
      ),
    );
  }
}
