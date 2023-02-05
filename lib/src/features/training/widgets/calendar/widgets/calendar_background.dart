import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class CalendarBackground extends StatelessWidget {
  final int fragmentHeight;

  const CalendarBackground({
    Key? key,
    this.fragmentHeight = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return List.filled(
      33,
      const SizedBox(
        height: 32,
        child: Divider(
          color: Colors.grey,
        ),
      ),
    ).toColumn();
  }
}
