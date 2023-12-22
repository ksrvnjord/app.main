// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class CharityProgressIndicator extends StatelessWidget {
  const CharityProgressIndicator({Key? key, required this.charityData})
      : super(key: key);

  final Map<String, dynamic>? charityData;

  @override
  Widget build(BuildContext context) {
    final int goal = charityData?['goal'] ?? 0;
    final int currentAmount = charityData?['current_amount'] ?? 0;

    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        final leftPosition = (currentAmount / goal) * constraints.maxWidth - 32;

        return Column(
          children: [
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: currentAmount / goal,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
              minHeight: 40,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "€ 0",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "€$goal",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                Positioned(
                  left: leftPosition,
                  child: Text(
                    // ignore: avoid-non-ascii-symbols
                    "€$currentAmount",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
