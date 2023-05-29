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
    final colorScheme = Theme.of(context).colorScheme;
    final Color availableColor = colorScheme.outline.withOpacity(0.5);
    final Color unavailableColor = availableColor.withOpacity(0.1);

    return [
      for (int i = 0; i < amountOfSlots; i++)
        SizedBox(
          height: slotHeight,
          child: Divider(
            thickness: thickness(i),
            color: available ? availableColor : unavailableColor,
          ),
        ),
    ].toColumn();
  }

  double thickness(int index) {
    const double unevenThickness = 0.25;

    return index.isEven ? 1 : unevenThickness;
  }
}
