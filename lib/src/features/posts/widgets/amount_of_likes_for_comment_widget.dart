import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ksrvnjord_main_app/assets/svgs.dart';
import 'package:styled_widget/styled_widget.dart';

class AmountOfLikesForCommentWidget extends StatelessWidget {
  final int amountOfLikes;

  const AmountOfLikesForCommentWidget({Key? key, required this.amountOfLikes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double shadowOpacity = 0.1726;
    const double shadowBlurRadius = 2;
    const double innerSpacing = 2;
    const double outerHPadding = 4;
    const double iconSize = 12;
    const double textFontSize = 12;

    return Container(
      // make edges round
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        color: Colors.lightBlue.shade300,
        // add shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(shadowOpacity),
            spreadRadius: 1,
            blurRadius: shadowBlurRadius,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: [
        SvgPicture.asset(
          Svgs.swanWhite,
          width: iconSize,
          // ignore: deprecated_member_use
          color: Colors.white,
          // ignore: no-equal-arguments
          height: iconSize,
        ),
        Text(amountOfLikes.toString())
            .fontWeight(FontWeight.bold)
            .fontSize(textFontSize)
            .textColor(Colors.white),
      ]
          .toRow(
            mainAxisSize: MainAxisSize.min,
            separator: const SizedBox(width: innerSpacing),
          )
          .padding(horizontal: outerHPadding),
    );
  }
}
