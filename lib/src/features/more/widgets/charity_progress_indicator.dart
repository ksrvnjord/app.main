// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/more/api/charity_get_leontien_huis.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_text_widget.dart';

class CharityProgressIndicator extends ConsumerWidget {
  const CharityProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charityVal = ref.watch(leontienhuisProvider);

    return charityVal.when(
      // ignore: avoid-long-functions
      data: (charityData) {
        final int goal = charityData['goal'] ?? 0;
        final int currentAmount = charityData['current_amount'] ?? 0;

        return LayoutBuilder(
          // ignore: avoid-long-functions
          builder: (BuildContext ctx, BoxConstraints constraints) {
            final leftPosition =
                (currentAmount / goal) * constraints.maxWidth - 32;

            return Column(
              children: [
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: currentAmount / goal,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.orange),
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
      },
      error: (err, stack) => ErrorTextWidget(errorMessage: err.toString()),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}
