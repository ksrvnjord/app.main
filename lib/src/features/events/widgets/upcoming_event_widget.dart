import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:styled_widget/styled_widget.dart';

class UpcomingEventWidget extends StatelessWidget {
  const UpcomingEventWidget({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    const double topPadding = 4;

    DateFormat monthFormat = DateFormat('MMM EEE', 'nl_NL');
    DateFormat timeFormat = DateFormat('HH:mm');
    const int maxLines = 2;
    DateTime start = event.startTime;

    final textTheme = Theme.of(context).textTheme;
    const double elementPadding = 4;

    const double timeTopPadding = 2;
    const double minWidthDay = 28;

    return [
      Text(
        start.day.toString(),
        style: textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ).constrained(
        minWidth: minWidthDay,
      ),
      Text(
        monthFormat.format(start),
        style: textTheme.labelLarge,
      ).padding(top: topPadding),
      Text(
        timeFormat.format(start),
        style: textTheme.labelMedium,
      ).padding(top: topPadding + timeTopPadding),
      Expanded(
        child: Text(
          event.title,
          style: textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
      ),
    ].toRow(
      separator: const SizedBox(width: elementPadding),
    );
  }
}
