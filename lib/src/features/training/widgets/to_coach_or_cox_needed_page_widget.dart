import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ToCoachOrCoxNeededPageWidget extends StatelessWidget {
  const ToCoachOrCoxNeededPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.goNamed('Coach Of Stuur Nodig'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
          // no background color — will inherit normal scaffold background
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Coach/Stuur nodig of worden?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
