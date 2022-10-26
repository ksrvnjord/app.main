import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/slots.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingDayList extends StatelessWidget {
  final DateTime date;
  final Boot boat;

  const TrainingDayList({
    Key? key,
    required this.date,
    required this.boat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DateTime> timestamps = List.generate(
        36,
        (index) =>
            DateTime(2020, 01, 01, 6, 0).add(Duration(minutes: index * 30)));

    var navigator = Routemaster.of(context);

    return SizedBox(
        width: 96,
        child: <Widget>[
          SizedBox(
              width: 96,
              height: 64,
              child: Text(boat.name,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))
                  .center()),
          Stack(children: <Widget>[
            SizedBox(
                width: 96,
                child: timestamps
                    .map<Widget>((e) => SizedBox(
                        height: 32,
                        width: 96,
                        child: IconButton(
                            icon: const Icon(LucideIcons.plusCircle,
                                size: 12, color: Colors.grey),
                            onPressed: () {
                              navigator.replace('plan', queryParameters: {
                                'reservationObjectName': 'De Vijf Pijlen',
                                'reservationObjectPath': '/reservationObjects/De Vijf Pijlen',
                                'hour': e.hour.toString(),
                                'minute': e.minute.toString(),
                                'date': date.toIso8601String()
                              });
                            })).border(
                        bottom: 1,
                        color: const Color.fromARGB(255, 245, 245, 245)))
                    .toList()
                    .toColumn(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center)),
            ...boat.slots.map<Widget>((e) {
              return Positioned(
                  top: ((((e.from.hour - 6) * 60) + (e.from.minute)) / 30) * 32,
                  child: Container(
                    width: 96,
                    height: (e.length.inMinutes / 30) * 32,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(width: 4, color: Colors.white)),
                  ));
            }).toList()
          ]).border(right: 1, color: const Color.fromARGB(255, 225, 225, 225))
        ].toColumn());
  }
}
