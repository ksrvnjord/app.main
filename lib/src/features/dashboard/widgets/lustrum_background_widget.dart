import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/assets/lustrum_colors.dart';

class LustrumBackgroundWidget extends CustomPainter {
  final double strokeSize = 0.03; // ignore: size height times this number
  final double offsetStripes =
      4.0; // ignore: value: 2.0 (stripes touching), value: 4.0 (stripe between)

  final double pageOffset;

  // ignore: sort_constructors_first
  LustrumBackgroundWidget({required this.pageOffset});
  @override
  void paint(Canvas canvas, Size size) {
    const opacity = 0.16;
    final orange = Paint()
      ..color = LustrumColors.secondaryOrange.withOpacity(opacity)
      ..strokeWidth = size.height * strokeSize;

    final blue = Paint()
      ..color = LustrumColors.lightBlue.withOpacity(opacity)
      ..strokeWidth = size.height * strokeSize;

    // ignore: Define paintstripes.
    // ignore: Only adjust the two doubles inside brackets of Orange
    // ignore: Or else adjust strokeSize and offsetStripes above.

    final dxOrangeStart = size.width * (1.04 + strokeSize * offsetStripes);
    final dyOrangeStart =
        -size.height * (strokeSize * offsetStripes) + pageOffset;
    final dxOrangeEnd = -size.width * (strokeSize * offsetStripes);
    final dyOrangeEnd = size.height * (1.03 + strokeSize * offsetStripes);
    canvas.drawLine(
      Offset(dxOrangeStart, dyOrangeStart),
      Offset(dxOrangeEnd, dyOrangeEnd),
      orange,
    );

    final dxBlueStart = dxOrangeStart * (1.0 + strokeSize * offsetStripes);
    final dyBlueStart =
        (dyOrangeStart - pageOffset) * (1.0 + strokeSize * offsetStripes) +
            pageOffset;
    final dxBlueEnd = dxOrangeEnd * (1.0 + strokeSize * offsetStripes);
    final dyBlueEnd = (dyOrangeEnd) * (1.0 + strokeSize * offsetStripes);
    canvas.drawLine(
      Offset(dxBlueStart, dyBlueStart),
      Offset(dxBlueEnd, dyBlueEnd),
      blue,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
