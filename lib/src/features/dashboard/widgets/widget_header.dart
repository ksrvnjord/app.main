import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class WidgetHeader extends StatelessWidget {
  const WidgetHeader({
    Key? key,
    required this.title,
    this.onTapName,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String? onTapName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const double headerFontSize = 16;

    return [
      Text(
        title,
      )
          .fontSize(headerFontSize)
          .fontWeight(FontWeight.w300)
          .textColor(Colors.blueGrey)
          .alignment(Alignment.center),
      if (onTap != null)
        GestureDetector(
          onTap: onTap,
          child: [
            if (onTapName != null) Text(onTapName!).textColor(Colors.blueGrey),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.blueGrey,
            ),
          ].toRow(
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ).alignment(Alignment.centerRight),
    ].toStack(
      alignment: Alignment.center,
    );
  }
}
