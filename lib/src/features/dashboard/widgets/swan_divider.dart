import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ksrvnjord_main_app/assets/svgs.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class SwanDivider extends StatelessWidget {
  const SwanDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const double smallSwanSize = 12;
    const double largeSwanSize = 16;
    const double horizontalPadding = 40;

    return [
      Expanded(
        child: Divider(
          color: colorScheme.primaryContainer,
        ),
      ),
      [
        for (final Tuple2<double, Color> color in [
          Tuple2(smallSwanSize, colorScheme.tertiaryContainer),
          Tuple2(largeSwanSize, colorScheme.primary),
          Tuple2(smallSwanSize, colorScheme.secondaryContainer),
        ])
          SvgPicture.asset(
            Svgs.swanWhite,
            width: color.item1,
            // ignore: deprecated_member_use
            color: color.item2,
          ),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        separator: const SizedBox(width: 8),
      ),
      Expanded(
        child: Divider(
          color: colorScheme.primaryContainer,
        ),
      ),
    ]
        .toRow(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          separator: const SizedBox(width: 8),
        )
        .padding(horizontal: horizontalPadding);
  }
}
