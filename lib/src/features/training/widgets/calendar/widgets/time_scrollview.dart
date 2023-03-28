import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_time.dart';
import 'package:styled_widget/styled_widget.dart';

import '../calendar_measurement.dart';

class TimeScrollView extends StatelessWidget {
  const TimeScrollView({
    super.key,
    required this.timesController,
  });

  final ScrollController timesController;

  @override
  Widget build(BuildContext context) {
    const double topLeftCornerHeight = 64;
    // calculate amount of minutes between 17:26 and 22:00

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics:
          const NeverScrollableScrollPhysics(), // who needs to scroll this anyways? you can't see the time if you scroll
      controller: timesController,
      child: Container(
        color: Colors.grey[50],
        child: CalendarTime().padding(top: topLeftCornerHeight),
      ),
    );
  }
}
