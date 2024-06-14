import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ksrvnjord_main_app/assets/svgs.dart';
import 'package:styled_widget/styled_widget.dart';

class AmountOfLikesForCommentWidget extends StatelessWidget {
  const AmountOfLikesForCommentWidget({super.key, required this.amountOfLikes});

  final int amountOfLikes;

  @override
  Widget build(BuildContext context) {
    const double shadowOpacity = 0.1726;
    const double shadowBlurRadius = 2;
    const double innerSpacing = 2;
    const double outerHPadding = 4;
    const double iconSize = 12;

    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = colorScheme.surface;
    final foregroundColor = colorScheme.primary;

    return Container(
      // Make edges round.
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(shadowOpacity),
            offset: const Offset(0, 1),
            blurRadius: shadowBlurRadius,
            spreadRadius: 1,
          ),
        ],
      ),
      child: [
        SvgPicture.asset(
          Svgs.swanWhite,
          width: iconSize,
          // ignore: no-equal-arguments
          height: iconSize,
          // ignore: deprecated_member_use
          color: foregroundColor,
        ),
        Text(
          amountOfLikes.toString(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: foregroundColor,
              ),
        ),
      ]
          .toRow(
            mainAxisSize: MainAxisSize.min,
            separator: const SizedBox(width: innerSpacing),
          )
          .padding(horizontal: outerHPadding),
    );
  }
}
