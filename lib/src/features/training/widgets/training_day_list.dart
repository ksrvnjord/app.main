import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/slots.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:routemaster/routemaster.dart';
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
  Widget build(BuildContext context) {
    final List<DateTime> timestamps = List.generate(
        32,
        (index) => DateTime(date.year, date.month, date.day, 6, 0)
            .add(Duration(minutes: index * 30)));

    var navigator = Routemaster.of(context);
    CollectionReference reservationRef =
        FirebaseFirestore.instance.collection('reservations');
    DateTime now = DateTime.now();

    List<DateTime> reservationsToReservedSlots(
        List<QueryDocumentSnapshot> reservations) {
      List<DateTime> forbiddenSlots = [];
      Duration interval = const Duration(minutes: 30);
      for (int i = 0; i < reservations.length; i++) {
        DateTime startTime = reservations[i].get('startTime').toDate();
        DateTime endTime = reservations[i].get('endTime').toDate();

        DateTime roundedStart = DateTime(
            startTime.year,
            startTime.month,
            startTime.day,
            startTime.hour,
            [0, 30][(endTime.minute / 30).floor()]);
        DateTime roundedEnd = DateTime(endTime.year, endTime.month, endTime.day,
            endTime.hour, [0, 30][(endTime.minute / 30).floor()]);

        DateTime current = roundedStart;
        while (current.isBefore(roundedEnd)) {
          forbiddenSlots.add(current);
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
                      isGreaterThanOrEqualTo:
                          DateTime(now.year, now.month, now.day, 0, 0, 0))
                  .where('startTime',
                      isLessThanOrEqualTo:
                          DateTime(now.year, now.month, now.day, 23, 59, 59))
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }

                List<DateTime> forbiddenSlots = [];
                if (snapshot.data?.docs != null) {
                  forbiddenSlots =
                      reservationsToReservedSlots(snapshot.data!.docs);
                }
                return Stack(children: <Widget>[
                  SizedBox(
                      width: 96,
                      child: timestamps
                          .map<Widget>((e) => SizedBox(
                                  height: 32,
                                  width: 96,
                                  child: forbiddenSlots.contains(e)
                                      ? Container(color: Colors.grey)
                                      : IconButton(
                                          icon: const Icon(
                                              LucideIcons.plusCircle,
                                              size: 12,
                                              color: Colors.grey),
                                          onPressed: () {
                                            navigator
                                                .push('plan', queryParameters: {
                                              'reservationObjectId': boat.id,
                                              // 'startTime': e.toIso8601String(),
                                              'startTime': (date) {
                                                return DateTime(2022, 9, 28,
                                                        date.hour, date.minute)
                                                    .toIso8601String();
                                              }(e),
                                            });
                                          }))
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
