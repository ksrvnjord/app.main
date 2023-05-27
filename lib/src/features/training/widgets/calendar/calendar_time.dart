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
    const double leftPaddingOfTime = 8;
    const double timeRightPadding = 18;

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
                    child: const Divider(color: Colors.grey),
                  ),
                  if (timestamp.minute == 0)
                    [
                      Text(
                        DateFormat('H:mm').format(timestamp),
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
