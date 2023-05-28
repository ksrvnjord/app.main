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

    DateFormat monthFormat = DateFormat('MMM EEE', 'nl_NL');
    DateFormat timeFormat = DateFormat('HH:mm');
    const int maxLines = 2;
    DateTime start = event.startTime;

    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          start.day.toString(),
          style: textTheme.headlineSmall,
        ).paddingDirectional(horizontal: elementPadding),
        Text(
          monthFormat.format(start),
          style: textTheme.labelLarge,
        ).padding(top: topPadding),
        Text(
          timeFormat.format(start),
          style: textTheme.labelMedium,
        ).padding(horizontal: elementPadding, top: topPadding),
        Expanded(
          child: Text(
            event.title,
            style: textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
          ).paddingDirectional(horizontal: elementPadding),
        ),
      ],
    );
  }
}
