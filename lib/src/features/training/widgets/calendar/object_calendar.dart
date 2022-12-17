import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/slots.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class ObjectCalendar extends StatefulWidget {
  final DateTime date;
  final QueryDocumentSnapshot<ReservationObject> boat;
  const ObjectCalendar({
    Key? key,
    required this.date,
    required this.boat,
  }) : super(key: key);

  @override
  State<ObjectCalendar> createState() => _ObjectCalendar();
}

class _ObjectCalendar extends State<ObjectCalendar> {
  late DateTime date;
  late QueryDocumentSnapshot<ReservationObject> boat;

  @override
  void initState() {
    super.initState();
    date = widget.date;
    boat = widget.boat;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime earliestDateTimeThatCanBeBooked =
        DateTime(date.year, date.month, date.day, 6, 0); // 6:00
    final DateTime latestDateTimeThatCanBeBooked =
        DateTime(date.year, date.month, date.day, 22, 0); // 22:00
    final DateTimeRange dateTimeRange = DateTimeRange(
        start: earliestDateTimeThatCanBeBooked,
        end: latestDateTimeThatCanBeBooked);
    final int minutes = dateTimeRange.duration.inMinutes;
    const int timeSlotSize = 30; // minutes

    final int amountOfSlots = minutes ~/ timeSlotSize;

    final List<DateTime> timestamps = List.generate(
        amountOfSlots,
        (i) => earliestDateTimeThatCanBeBooked
            .add(Duration(minutes: i * timeSlotSize)));

    var navigator = Routemaster.of(context);
    CollectionReference reservationRef =
        FirebaseFirestore.instance.collection('reservations');
    DateTime now = DateTime.now();

    List<Map<String, dynamic>> reservationsToReservedSlots(
        List<QueryDocumentSnapshot> reservations) {
      List<Map<String, dynamic>> forbiddenSlots = [];
      Duration interval = const Duration(minutes: timeSlotSize);
      for (int i = 0; i < reservations.length; i++) {
        DateTime startTime = reservations[i].get('startTime').toDate();
        DateTime endTime = reservations[i].get('endTime').toDate();
        DateTime roundedStart = DateTime(
            startTime.year,
            startTime.month,
            startTime.day,
            startTime.hour,
            [0, timeSlotSize][(startTime.minute / timeSlotSize).floor()]);
        DateTime roundedEnd = DateTime(
            endTime.year,
            endTime.month,
            endTime.day,
            endTime.hour,
            [0, timeSlotSize][(endTime.minute / timeSlotSize).floor()]);
        DateTime current = roundedStart;
        while (current.isBefore(roundedEnd)) {
          forbiddenSlots
              .add({'time': current, 'reservationId': reservations[i].id});
          current = current.add(interval);
        }
      }
      return forbiddenSlots;
    }

    return SizedBox(
        width: 96,
        child: <Widget>[
          FutureBuilder(
              future: reservationRef
                  .where('object', isEqualTo: boat.reference)
                  .where('startTime',
                      isGreaterThanOrEqualTo: earliestDateTimeThatCanBeBooked)
                  .where('startTime',
                      isLessThanOrEqualTo: latestDateTimeThatCanBeBooked)
                  .get(const GetOptions(source: Source.serverAndCache)),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const ErrorCardWidget(
                      errorMessage:
                          "Er is iets misgegaan bij het ophalen van de afschrijvingen");
                }

                List<Map<String, dynamic>> forbiddenSlots = [];
                if (snapshot.data?.docs != null) {
                  forbiddenSlots =
                      reservationsToReservedSlots(snapshot.data!.docs);
                }
                return Stack(children: <Widget>[
                  SizedBox(
                      width: 96,
                      child: timestamps
                          .map<Widget>((timestamp) => SizedBox(
                                  height: 32,
                                  width: 96,
                                  child: () {
                                    // check if forbiddenslots contains timestamp
                                    bool reserved = false;
                                    for (Map<String, dynamic> forbiddenSlot
                                        in forbiddenSlots) {
                                      if (forbiddenSlot['time'] == timestamp) {
                                        reserved = true;
                                        return GestureDetector(
                                            onTap: () {
                                              navigator.push(forbiddenSlot[
                                                  'reservationId']);
                                            },
                                            child:
                                                Container(color: Colors.grey));
                                      }
                                    }
                                    if (reserved) {
                                      // ignore: empty_statements
                                      ;
                                    } else if (FirebaseAuth
                                            .instance.currentUser ==
                                        null) {
                                      return Container(
                                          color: const Color.fromARGB(
                                              255, 245, 245, 245));
                                    } else {
                                      return IconButton(
                                          icon: const Icon(
                                              LucideIcons.plusCircle,
                                              size: 12,
                                              color: Colors.grey),
                                          onPressed: () {
                                            navigator
                                                .push('plan', queryParameters: {
                                                  'reservationObjectId':
                                                      boat.id,
                                                  'reservationObjectName':
                                                      boat.get('name'),
                                                  'startTime': timestamp
                                                      .toIso8601String(),
                                                })
                                                .result
                                                .then((success) {
                                                  if (success == true) {
                                                    setState(() =>
                                                        {}); // refresh page
                                                  }
                                                });
                                          });
                                    }
                                  }())
                              .border(
                                  bottom: 1,
                                  color:
                                      const Color.fromARGB(255, 245, 245, 245)))
                          .toList()
                          .toColumn(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center)),
                  ...[].map<Widget>((e) {
                    return Positioned(
                        top: ((((e.from.hour - 6) * 60) + (e.from.minute)) /
                                30) *
                            32,
                        child: Container(
                          width: 96,
                          height: (e.length.inMinutes / 30) * 32,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              border:
                                  Border.all(width: 4, color: Colors.white)),
                        ));
                  }).toList()
                ]).border(
                    right: 1, color: const Color.fromARGB(255, 225, 225, 225));
              })
        ].toColumn());
  }
}
