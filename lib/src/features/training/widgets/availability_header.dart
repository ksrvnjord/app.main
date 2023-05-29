import 'package:flutter/material.dart';

class AvailabilityHeader extends StatelessWidget {
  const AvailabilityHeader({
    super.key,
    required this.isAvailable,
  });

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    String text = isAvailable ? "Beschikbaar" : "Niet beschikbaar";
    final colorScheme = Theme.of(context).colorScheme;
    Color color =
        isAvailable ? colorScheme.primaryContainer : colorScheme.errorContainer;

    return Row(children: [
      Expanded(
        child: Card(
          color: color,
          elevation: 0,
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isAvailable
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onErrorContainer,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ]);
  }
}
