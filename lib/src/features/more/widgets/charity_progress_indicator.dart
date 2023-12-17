import 'package:flutter/material.dart';

class CharityProgressIndicator extends StatelessWidget {
  final Map<String, dynamic>? charityData;

  const CharityProgressIndicator({Key? key, required this.charityData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int goal = charityData?['goal'] ?? 0;
    int currentAmount = charityData?['current_amount'] ?? 0;
    double screenWidth = MediaQuery.of(context).size.width - 130;

    return SizedBox(
      width: double.infinity,
      child: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "€ 0",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: currentAmount / goal * screenWidth,
              ),
              Text(
                "€$currentAmount",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: (1 - currentAmount / goal) * screenWidth,
              ),
              Text(
                "€$goal",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
