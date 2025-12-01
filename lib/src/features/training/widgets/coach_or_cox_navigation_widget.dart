import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CoachOrCoxNavigationWidget extends StatelessWidget {
  // 'coach' or 'stuur'
  const CoachOrCoxNavigationWidget({
    super.key,
    required this.label,
    required this.routeName,
    required this.role,
  });

  final String label;
  final String routeName;
  final String role;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.goNamed(routeName, pathParameters: {'role': role}),
      borderRadius: BorderRadius.circular(8), // less rounded
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10), // slightly slimmer
        margin: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6), // less margin vertically
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // match InkWell
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15, // slightly smaller
                fontWeight: FontWeight.w500, // lighter
                color: colorScheme.primary,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
