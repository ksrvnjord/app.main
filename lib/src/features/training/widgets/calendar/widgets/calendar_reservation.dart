import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class CalendarReservation extends StatelessWidget {
  final int fragmentHeight;
  final dynamic data;
  final String? id;

  const CalendarReservation({
    Key? key,
    this.data,
    this.id,
    this.fragmentHeight = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      // Calculate the offset of the reservation
      DateTime timestamp = (data['startTime'] as Timestamp).toDate();
      Duration offset = timestamp.difference(
          DateTime(timestamp.year, timestamp.month, timestamp.day, 6, 0, 0));

      // Calculate the duration of the reservation
      double duration = ((data['endTime'] as Timestamp).seconds -
              (data['startTime'] as Timestamp).seconds) /
          3600;

      final navigator = Routemaster.of(context);

      return [
        GestureDetector(
            onTap: () {
              id != null ? navigator.push(id!) : null;
            },
            child: Container(
                width: 128,
                height: duration * 32 * 2,
                decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Text(data['creatorName'] ?? 'Afschrijving',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )).padding(all: 4)))
      ].toColumn().padding(top: 16 + ((offset.inMinutes / 30) * 32));
    }

    return Container();
  }
}
