import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/vaarverbod_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class VaarverbodWidget extends ConsumerWidget {
  const VaarverbodWidget({
    super.key,
  });

  static const double textSize = 14;
  static const double cardInnerPadding = 8;
  static const double iconRightPadding = 12;
  static const double cardWidth = 144;
  static const double cardElementHPadding = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaarverbodRef = ref.watch(vaarverbodProvider);

    return SizedBox(
      width: cardWidth,
      child: vaarverbodRef.when(
        data: (data) => Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          elevation: 0,
          color: data.status ? Colors.red[300] : Colors.green[300],
          child: [
            // should shield check icon
            FaIcon(
              data.status
                  ? FontAwesomeIcons.ban
                  : FontAwesomeIcons.shieldHalved,
              color: Colors.white,
            ).padding(
              horizontal: cardElementHPadding,
            ),
            Text(data.message)
                .textColor(Colors.white)
                .fontSize(textSize)
                .textAlignment(TextAlign.end)
                .fontWeight(FontWeight.bold)
                .padding(horizontal: cardElementHPadding)
                .expanded(),
          ]
              .toRow(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
              )
              .padding(all: cardInnerPadding),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const ErrorCardWidget(
          errorMessage:
              "Het is niet gelukt om het vaarverbod op te halen van de server.",
        ),
      ),
    );
  }
}
