import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

class CalendarTime extends StatelessWidget {
  CalendarTime({
    Key? key,
  }) : super(key: key);

  final List<DateTime> timestamps = List.generate(
    33,
    (index) => DateTime(2020, 01, 01, 6, 0).add(Duration(minutes: index * 30)),
  );

  @override
  Widget build(BuildContext context) {
    const double timeWidth = 64;
    const double timeHeight = 32;

    return SizedBox(
      width: timeWidth,
      child: timestamps
          .map<Widget>((timestamp) => SizedBox(
                height: timeHeight,
                width: timeWidth,
                child: Stack(children: [
                  Container(
                    padding: const EdgeInsets.only(left: 60),
                    height: timeHeight,
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
