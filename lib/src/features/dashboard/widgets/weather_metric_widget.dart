import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherMetricWidget extends StatelessWidget {
  const WeatherMetricWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.mainText,
    this.main,
    this.bottomText,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String mainText;
  final Widget? main;
  final String? bottomText;

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 128;

    const double headerIconSize = 14;
    const double mainTextSize = 24;
    const double headerTextSize = 14;
    const double bottomTextSize = 12;
    const double innerPadding = 10;

    return SizedBox(
      height: cardHeight,
      child: [
        [
          [
            BoxedIcon(icon, size: headerIconSize, color: Colors.white),
            Text(title)
                .textColor(Colors.white)
                .fontSize(headerTextSize)
                .fontWeight(
                  FontWeight.w600,
                ),
          ].toRow(
            mainAxisSize: MainAxisSize.min,
            separator: const SizedBox(width: 4),
          ),
          Text(mainText)
              .textColor(Colors.white)
              .fontSize(mainTextSize)
              .fontWeight(
                FontWeight.bold,
              ),
          main ?? const SizedBox(),
        ].toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        if (bottomText != null)
          Text(bottomText ?? "")
              .textColor(Colors.white)
              .fontSize(bottomTextSize),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
          .padding(all: innerPadding)
          .card(
            color: Colors.blue[400],
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
    );
  }
}
