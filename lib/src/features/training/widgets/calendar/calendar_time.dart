import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_measurement.dart';
import 'package:styled_widget/styled_widget.dart';

class CalendarTime extends StatelessWidget {
  CalendarTime({
    Key? key,
  }) : super(key: key);

  final List<DateTime> timestamps = List.generate(
    CalendarMeasurement.amountOfSlots,
    (index) => DateTime(2020, 01, 01, CalendarMeasurement.startHour, 0)
        .add(Duration(minutes: index * CalendarMeasurement.minutesInSlot)),
  );

  @override
  Widget build(BuildContext context) {
    const double timeWidth = 64;
    const double smallTicks = 56;
    const double bigTicks = 50;
    const double leftPaddingOfTime = 4;
    const double timeRightPadding = 16;

    final colorScheme = Theme.of(context).colorScheme;
    final Color availableColor = colorScheme.outline.withOpacity(0.5);
    const double thicknessSmallTicks = 0.25;

    return SizedBox(
      width: timeWidth,
      child: timestamps
          .map<Widget>((timestamp) => SizedBox(
                width: timeWidth,
                height: CalendarMeasurement.slotHeight,
                child: Stack(children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: timestamp.minute == 0 ? bigTicks : smallTicks,
                    ),
                    height: CalendarMeasurement.slotHeight,
                    child: Divider(
                      height: 1,
                      thickness:
                          timestamp.minute == 0 ? 1 : thicknessSmallTicks,
                      color: availableColor,
                    ),
                  ),
                  if (timestamp.minute == 0)
                    [
                      Text(
                        DateFormat('HH:mm').format(timestamp),
                        style: Theme.of(context).textTheme.labelLarge,
                      ).center(),
                    ]
                        .toRow(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                        )
                        .padding(
                          left: leftPaddingOfTime,
                          right: timeRightPadding,
                        ),
                ]),
              ))
          .toList()
          .toColumn(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
    );
  }
}
