import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/vaarverbod_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class VaarverbodWidget extends ConsumerWidget {
  const VaarverbodWidget({
    super.key,
  });

  static const double textSize = 14;
  static const double cardInnerPadding = 8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaarverbodRef = ref.watch(vaarverbodProvider);

    return vaarverbodRef.when(
      data: (data) => Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        elevation: 0,
        color: data.status ? Colors.red : Colors.green,
        child: [
          Text(data.message)
              .textColor(Colors.white)
              .fontSize(textSize)
              .fontWeight(FontWeight.bold)
              .expanded(),
        ].toRow().padding(all: cardInnerPadding),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const ErrorCardWidget(
        errorMessage:
            "Het is niet gelukt om het vaarverbod op te halen van de server.",
      ),
    );
  }
}
