import 'package:flutter/material.dart';

class CharityHelpedVisualisation extends StatelessWidget {
  final num currentAmount;
  final num goal;
  final num pricePerPerson;

  const CharityHelpedVisualisation({
    super.key,
    required this.currentAmount,
    required this.goal,
    required this.pricePerPerson,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < currentAmount ~/ pricePerPerson; i++)
          const Icon(Icons.person, size: 40.0, color: Colors.white),
        for (num i = currentAmount ~/ pricePerPerson;
            i < goal ~/ pricePerPerson;
            i++)
          const Icon(Icons.person, size: 40.0, color: Colors.grey),
      ],
    );
  }
}
