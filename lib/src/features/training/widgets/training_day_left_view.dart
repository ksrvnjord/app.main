import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingDayLeftView extends StatelessWidget {
  TrainingDayLeftView({
    Key? key,
  }) : super(key: key);

  final List<DateTime> timestamps = List.generate(
      32,
      (index) =>
          DateTime(2020, 01, 01, 6, 0).add(Duration(minutes: index * 30)));

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      const SizedBox(width: 64, height: 64),
      SizedBox(
          width: 64,
          child: timestamps
              .map<Widget>((e) => SizedBox(
                  height: 32,
                  width: 64,
                  child: Text(DateFormat('Hm').format(e),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )).center()))
              .toList()
              .toColumn(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center))
      //.border(right: 1)
    ].toColumn();
  }
}
