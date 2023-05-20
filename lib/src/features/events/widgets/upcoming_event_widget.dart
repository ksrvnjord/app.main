import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:styled_widget/styled_widget.dart';

class UpcomingEventWidget extends StatelessWidget {
  const UpcomingEventWidget({
    super.key,
    required this.elementPadding,
    required this.event,
  });

  final double elementPadding;
  final Event event;

  @override
  Widget build(BuildContext context) {
    const double topPadding = 8;
    const double dayNumberFontSize = 24;
    DateFormat monthFormat = DateFormat('MMM EEE', 'nl_NL');
    const double dateFontSize = 12;
    DateFormat timeFormat = DateFormat('HH:mm');
    const int maxLines = 2;
    const double eventFontSize = 16;
    DateTime start = event.startTime;

    return Row(
      children: [
        Text(start.day.toString())
            .fontSize(dayNumberFontSize)
            .paddingDirectional(horizontal: elementPadding),
        Text(
          monthFormat.format(start),
        )
            .fontSize(dateFontSize)
            .textColor(Colors.blueGrey)
            .padding(top: topPadding),
        Text(timeFormat.format(start))
            .fontSize(dateFontSize)
            .textColor(Colors.blueGrey)
            .padding(horizontal: elementPadding, top: topPadding),
        Expanded(
          child: Text(
            event.title,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
          )
              .fontSize(eventFontSize)
              .paddingDirectional(horizontal: elementPadding),
        ),
      ],
    );
  }
}
