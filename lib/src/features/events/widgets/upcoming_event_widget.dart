import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/events/models/event.dart';
import 'package:styled_widget/styled_widget.dart';
// import 'package:universal_html/html.dart';

class UpcomingEventWidget extends StatelessWidget {
  const UpcomingEventWidget({
    super.key,
    required this.doc,
  });

  final QueryDocumentSnapshot<Event> doc;

  @override
  Widget build(BuildContext context) {
    const double topPadding = 4;

    DateFormat monthFormat = DateFormat('MMM', 'nl_NL');
    DateFormat dayFormat = DateFormat('EEE', 'nl_NL');
    DateFormat timeFormat = DateFormat('HH:mm');
    const int maxLines = 2;

    final event = doc.data();
    final DateTime start = event.startTime.toDate();
    final DateTime end = event.endTime.toDate();

    final textTheme = Theme.of(context).textTheme;
    const double elementPadding = 4;

    const double timeTopPadding = 0;
    const double minWidthDay = 28;

    return [
      Text(
        dayFormat.format(start),
        style: textTheme.labelLarge,
        textAlign: TextAlign.center,
      ).padding(top: topPadding),
      Text(
        start.day.toString(),
        style: textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ).constrained(
        minWidth: minWidthDay,
      ),
      if (start.day != end.day) ...[
        Text(
          '–',
          style: textTheme.labelLarge,
        ).padding(top: topPadding + timeTopPadding),
        Text(
          end.day.toString(),
          style: textTheme.headlineSmall,
          textAlign: TextAlign.left,
        ).constrained(
          minWidth: minWidthDay,
        ),
      ],
      Text(
        monthFormat.format(start),
        style: textTheme.labelLarge,
        textAlign: TextAlign.center,
      ).padding(top: topPadding),

      // Text(
      //   monthFormat.format(start),
      //   style: textTheme.labelLarge,
      // ).padding(top: topPadding),
      // if (start.day != end.day) ...[
      //   Text(
      //     '–',
      //     style: textTheme.labelLarge,
      //   ).padding(top: topPadding + timeTopPadding),
      //   Text(
      //     end.day.toString(),
      //     style: textTheme.headlineSmall,
      //     textAlign: TextAlign.center,
      //   ).constrained(
      //     minWidth: minWidthDay,
      //   ),
      //   Text(
      //     monthFormat.format(end),
      //     style: textTheme.labelLarge,
      //   ).padding(top: topPadding),
      // ],
      if (start.day == end.day)
        Text(
          timeFormat.format(start),
          style: textTheme.titleMedium,
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
