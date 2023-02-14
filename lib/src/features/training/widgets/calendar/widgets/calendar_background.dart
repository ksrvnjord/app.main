import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_measurement.dart';
import 'package:styled_widget/styled_widget.dart';

class CalendarBackground extends StatelessWidget {
  const CalendarBackground({
    Key? key,
    this.available = true,
  }) : super(key: key);

  final bool available;

  @override
  Widget build(BuildContext context) {
    const int amountOfSlots = CalendarMeasurement.amountOfSlots;
    const double slotHeight = CalendarMeasurement.slotHeight;

    const Color unavailableColor = Color.fromARGB(255, 230, 230, 230);
    const Color availableColor = Colors.grey;

    return List.filled(
      amountOfSlots,
      SizedBox(
        height: slotHeight,
        child: Divider(
          color: available ? availableColor : unavailableColor,
        ),
      ),
    ).toColumn();
  }
}
