import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class _PlanTrainingPageState extends State<PlanTrainingPage> {
  final String reservationObjectPath;
  final String reservationObjectName;
  final int hour;
  final int minute;
  final DateTime date;
  late DateTime _startTime;
  late DateTime _endTime;

  _PlanTrainingPageState({required Map<String, dynamic> queryParams})
      : reservationObjectPath = queryParams['reservationObjectPath'] as String,
        reservationObjectName = queryParams['reservationObjectName'] as String,
        hour = int.parse(queryParams['hour']),
        minute = int.parse(queryParams['minute']),
        date = DateTime.parse(queryParams['date'] as String) {
    _startTime = DateTime(date.year, date.month, date.day, hour, minute);
    _endTime = _startTime.add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference<Reservation> reservationsRef =
        db.collection('reservations').withConverter<Reservation>(
              fromFirestore: (snapshot, _) =>
                  Reservation.fromJson(snapshot.data()!),
              toFirestore: (reservation, _) => reservation.toJson(),
            );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuwe Afschrijving'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: StreamBuilder<QuerySnapshot<Reservation>>(
        stream:
            reservationsRef // query all afschrijvingen van die dag van die boot
                // .where('object', isEqualTo: reservationObjectPath)
                // .where('startTime', isGreaterThanOrEqualTo: date)
                // .where('startTime',
                //     isLessThanOrEqualTo: date.add(const Duration(days: 1)))
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;
          // find last reservation that ends before the start time
          // find first reservation that starts after the end time
          DateTime earliestPossibleTime = date.add(const Duration(
              hours: 6)); // people can reservate starting at 06:00

          DateTime latestPossibleTime = date.add(const Duration(hours: 22));
          for (QueryDocumentSnapshot<Reservation> document in data.docs) {
            // determine earliest/latest possible time for slider
            Reservation reservation = document.data();
            if (reservation.endTime.isBefore(_startTime) &&
                reservation.endTime.isAfter(earliestPossibleTime)) {
              earliestPossibleTime = reservation.endTime;
            }
            if (reservation.startTime.isBefore(latestPossibleTime) &&
                reservation.startTime.isAfter(_startTime)) {
              latestPossibleTime = reservation.startTime;
            }
          }

          if (_endTime.isAfter(latestPossibleTime)) {
            _endTime = latestPossibleTime;
          }
          // bepaal laatste eindtijd die voor de starttijd ligt
          // bepaal eerste starttijd die na de eindtijd ligt
          return <Widget>[
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Afschrijven',
                border: OutlineInputBorder(),
              ),
              initialValue: reservationObjectName,
            ).padding(all: 15),
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Dag',
                border: OutlineInputBorder(),
              ),
              initialValue: DateFormat.yMMMMd().format(date),
            ).padding(all: 15),
            SfRangeSlider(
              min: earliestPossibleTime,
              max: latestPossibleTime,
              values: SfRangeValues(_startTime, _endTime),
              dragMode: SliderDragMode.both,
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              dateFormat: DateFormat.Hm(),
              stepDuration: const SliderStepDuration(minutes: 15),
              dateIntervalType: DateIntervalType.hours,
              interval: 1,
              minorTicksPerInterval: 3,
              onChanged: (SfRangeValues values) {
                setState(() {
                  _startTime = values.start;
                  _endTime = values.end;
                });
              },
            ).padding(all: 15),
            ElevatedButton(
                    onPressed: () => {
                          // reservationsRef
                          //     .add({
                          //       'object': reservationObjectPath,
                          //       'creatorId': 21203,
                          //       'startTime': Timestamp.fromDate(startTime),
                          //       'endTime': Timestamp.fromDate(endTime),
                          //       'createdTime': DateTime.now(),
                          //     })
                          //     .then((value) => print("Afschrijving Added"))
                          //     .catchError(
                          //         (error) => print("Failed to add user: $error")),
                          // navigator.push('/training')
                        },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue),
                    child: <Widget>[
                      const Icon(LucideIcons.check).padding(bottom: 1),
                      const Text('Afschrijven', style: TextStyle(fontSize: 18))
                          .padding(vertical: 16)
                    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween))
                .padding(all: 16)
            // Text('Menu om mensen uit te nodigen...'), TODO: not essential for first release
          ].toColumn().padding(all: 16);
        },
      ),
    );
  }
}

class PlanTrainingPage extends StatefulWidget {
  final String reservationObjectPath;
  final String reservationObjectName;
  final int hour;
  final int minute;
  final DateTime date;
  final Map<String, dynamic> queryParams;

  PlanTrainingPage({Key? key, required Map<String, dynamic> queryParams})
      : reservationObjectPath = queryParams['reservationObjectPath'] as String,
        reservationObjectName = queryParams['reservationObjectName'] as String,
        hour = int.parse(queryParams['hour']),
        minute = int.parse(queryParams['minute']),
        date = DateTime.parse(
            queryParams['date'] as String), // TODO: round to begin of day
        queryParams = queryParams,
        super(key: key);

  @override
  State<PlanTrainingPage> createState() =>
      _PlanTrainingPageState(queryParams: queryParams);
}
