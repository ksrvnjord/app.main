import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class MoreListTile extends StatelessWidget {
  final String label;
  final String routePath;

  const MoreListTile({
    super.key,
    required this.label,
    required this.routePath,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      visualDensity: VisualDensity.standard,
      onTap: () => Routemaster.of(context).push(routePath),
    );
  }
}
