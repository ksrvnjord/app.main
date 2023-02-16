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
    Color color = isAvailable ? Colors.lightGreen : Colors.red;

    return Row(children: [
      Expanded(
        child: Card(
          margin: const EdgeInsets.only(bottom: 4),
          color: color,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              // In this case we can pass the same value to both
              // ignore: no-equal-arguments
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
        ),
      ),
    ]);
  }
}
