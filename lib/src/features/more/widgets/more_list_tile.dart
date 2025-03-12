import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoreListTile extends StatelessWidget {
  const MoreListTile({
    super.key,
    required this.label,
    required this.routeName,
  });
  final String label;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      visualDensity: VisualDensity.standard,
      onTap: () => context.goNamed(routeName),
    );
  }
}
