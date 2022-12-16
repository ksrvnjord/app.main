import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_day_list_function.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_day_list_gridcell.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingDayList extends StatelessWidget {
  final DateTime date;
  final QueryDocumentSnapshot<ReservationObject> boat;

  const TrainingDayList({
    Key? key,
    required this.date,
    required this.boat,
  }) : super(key: key);

  @override
  build(BuildContext context) {
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

    CollectionReference reservationRef =
        FirebaseFirestore.instance.collection('reservations');

    return (StreamBuilder(
        stream: reservationRef
            .where('object', isEqualTo: boat.reference)
            .where('startTime',
                isGreaterThanOrEqualTo: earliestDateTimeThatCanBeBooked)
            .where('startTime',
                isLessThanOrEqualTo: latestDateTimeThatCanBeBooked)
            .snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const ErrorCardWidget(
                errorMessage:
                    "Er is iets misgegaan bij het ophalen van de afschrijvingen");
          } else {
            List<QueryDocumentSnapshot>? reservations = snapshot.data?.docs;
            List<DateTime> forbiddenSlots =
                reservationsToReservedSlots(reservations ?? [], timeSlotSize);
            return Stack(children: <Widget>[
              SizedBox(
                  width: 96,
                  child: timestamps
                      .map<Widget>((timestamp) => SizedBox(
                              height: 32,
                              width: 96,
                              child: FutureBuilder(
                                future: FirebaseAuth.instance.currentUser!
                                    .getIdTokenResult(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<IdTokenResult> snapshot) {
                                  if (snapshot.hasData) {
                                    return TrainingDayListGridCell(
                                        boat: boat,
                                        forbiddenSlots: forbiddenSlots,
                                        timestamp: timestamp,
                                        user: snapshot);
                                  }

                                  if (snapshot.hasError) {
                                    return Container();
                                  }

                                  return const CircularProgressIndicator();
                                },
                              ))
                          .border(
                              bottom: 1,
                              color: const Color.fromARGB(255, 245, 245, 245)))
                      .toList()
                      .toColumn(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center)),
              ...[].map<Widget>((e) {
                return Positioned(
                    top: ((((e.from.hour - 6) * 60) + (e.from.minute)) / 30) *
                        32,
                    child: Container(
                      width: 96,
                      height: (e.length.inMinutes / 30) * 32,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          border: Border.all(width: 4, color: Colors.white)),
                    ));
              }).toList()
            ]).border(
                right: 1, color: const Color.fromARGB(255, 225, 225, 225));
          }
        }));
  }
}
