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
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, color: Colors.lightBlue),
      visualDensity: VisualDensity.standard,
      onTap: () => navigateToPathIn(context),
    );
  }

  void navigateToPathIn(BuildContext context) {
    Routemaster.of(context).push(routePath);
  }
}
