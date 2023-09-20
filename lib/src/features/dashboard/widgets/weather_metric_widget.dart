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
    const double innerPadding = 10;

    final textTheme = Theme.of(context).textTheme;
    const double cardElevation = 5;

    return SizedBox(
      height: cardHeight,
      child: [
        [
          [
            BoxedIcon(
              icon,
              size: headerIconSize,
            ),
            Text(
              title,
              style: textTheme.titleSmall,
            ),
          ].toRow(
            mainAxisSize: MainAxisSize.min,
            separator: const SizedBox(width: 4),
          ),
          Text(
            mainText,
            style: textTheme.headlineSmall,
          ),
          main ?? const SizedBox(),
        ].toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        if (bottomText != null)
          Text(
            bottomText ?? "",
            style: textTheme.labelMedium,
          ),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
          .padding(all: innerPadding)
          .card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            elevation: cardElevation,
          ),
    );
  }
}
