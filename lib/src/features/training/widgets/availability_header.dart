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
            color: color,
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            margin: const EdgeInsets.only(bottom: 4),
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.center)),
      ),
    ]);
  }
}
