import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/vaarverbod_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/model/vaarverbod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class VaarverbodWidget extends ConsumerWidget {
  const VaarverbodWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(vaarverbodProvider).when(
          data: (data) => _buildVaarverbodCard(vaarverbod: data),
          loading: () => ShimmerWidget(
            child: _buildVaarverbodCard(),
          ),
          error: (error, stack) => _buildVaarverbodCard(),
        );
  }

  Widget _buildVaarverbodCard({Vaarverbod? vaarverbod}) {
    const double textSize = 14;
    const double cardInnerPadding = 8;
    const double boxWidth = 128;
    const double boxHeight = 56;
    const double cardElementHPadding = 4;

    IconData icon;
    String message;
    bool status;
    String tooltipMessage = vaarverbod?.message ?? 'Laden...';
    if (vaarverbod == null) {
      icon = FontAwesomeIcons.circleExclamation;
      message = 'Niet gelukt om te laden';
      status = true;
    } else {
      message =
          vaarverbod.status ? 'Er is een vaarverbod' : 'Er is geen vaarverbod';
      status = vaarverbod.status;
      if (vaarverbod.status) {
        icon = FontAwesomeIcons.ban;
      } else {
        icon = FontAwesomeIcons.shieldHalved;
      }
    }

    return Tooltip(
      // show tooltip on tap of the card
      enableFeedback: true,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(milliseconds: 2 * 1726),
      message: tooltipMessage,
      child: SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: [
          // should shield check icon
          FaIcon(
            icon,
            color: Colors.white,
          ),
          Text(
            message,
          )
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
              separator: const SizedBox(width: cardElementHPadding),
            )
            .padding(horizontal: cardInnerPadding),
      ).card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        elevation: 0,
        color: status ? Colors.red[300] : Colors.green[300],
      ),
    );
  }
}
