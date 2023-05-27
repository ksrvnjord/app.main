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
    Color color = isAvailable
        ? Colors.lightGreen.shade100
        : Theme.of(context).colorScheme.errorContainer;

    return Row(children: [
      Expanded(
        child: Card(
          color: color,
          elevation: 0,
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ]);
  }
}
