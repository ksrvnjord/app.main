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

    return SizedBox(
      width: timeWidth,
      child: timestamps
          .map<Widget>((timestamp) => SizedBox(
                height: CalendarMeasurement.slotHeight,
                width: timeWidth,
                child: Stack(children: [
                  Container(
                    padding: const EdgeInsets.only(left: 54),
                    height: CalendarMeasurement.slotHeight,
                    child: const Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    DateFormat('Hm').format(timestamp),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ).center(),
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
