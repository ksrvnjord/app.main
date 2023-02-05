import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class CalendarBackground extends StatelessWidget {
  const CalendarBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int amountOfSlots = 33;
    const double slotHeight = 32;

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
