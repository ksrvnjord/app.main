import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_measurement.dart';
import 'package:styled_widget/styled_widget.dart';

class CalendarBackground extends StatelessWidget {
  const CalendarBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int amountOfSlots = CalendarMeasurement.amountOfSlots;
    const double slotHeight = CalendarMeasurement.slotHeight;

    return List.filled(
      amountOfSlots,
      const SizedBox(
        height: slotHeight,
        child: Divider(
          color: Colors.grey,
        ),
      ),
    ).toColumn();
  }
}
