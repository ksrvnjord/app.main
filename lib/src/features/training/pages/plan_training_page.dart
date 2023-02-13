import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:routemaster/routemaster.dart';
import '../../settings/api/me.graphql.dart';
import '../../shared/model/current_user.dart';
import '../../shared/widgets/error_card_widget.dart';
import '../model/reservation.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:cloud_functions/cloud_functions.dart';

// HELP: What to do with these 'constants'. Maybe make a separate file to store them?
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: 'europe-west1');
final CollectionReference<Reservation> reservationsRef = db
    .collection('reservations')
    .withConverter<Reservation>(
      fromFirestore: (snapshot, _) => Reservation.fromJson(snapshot.data()!),
      toFirestore: (reservation, _) => reservation.toJson(),
    );

final CollectionReference<ReservationObject> reservationObjectsRef =
    db.collection('reservationObjects').withConverter<ReservationObject>(
          fromFirestore: (snapshot, _) =>
              ReservationObject.fromJson(snapshot.data()!),
          toFirestore: (reservation, _) => reservation.toJson(),
        );

final FirebaseAuth auth = FirebaseAuth.instance;

class PlanTrainingPage extends StatefulWidget {
  final DocumentReference reservationObject;
  final DateTime startTime;
  late final DateTime date;
  late final String objectName;

  PlanTrainingPage({Key? key, required Map<String, dynamic> queryParams})
      : reservationObject = db
            .collection('reservationObjects')
            .doc(queryParams['reservationObjectId']),
        startTime = DateTime.parse(queryParams['startTime']),
        objectName = queryParams['reservationObjectName'],
        super(key: key) {
    date = DateTime(startTime.year, startTime.month, startTime.day);
  }

  @override
  State<PlanTrainingPage> createState() => _PlanTrainingPageState();
}

class _PlanTrainingPageState extends State<PlanTrainingPage> {
  late DateTime _startTime; // Selected start time of the slider
  late DateTime _endTime; // Selected end time of the slider
  late TimeOfDay _startTimeOfDay; // Selected start time of the slider
  late TimeOfDay _endTimeOfDay; // Selected end time of the slider

  static const intervalOfSelector = Duration(minutes: 30);
  static const minimumReservationDuration = Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime;
    _endTime = widget.startTime.add(const Duration(hours: 1));
    _startTimeOfDay =
        TimeOfDay(hour: _startTime.hour, minute: _startTime.minute);
    _endTimeOfDay = TimeOfDay(hour: _endTime.hour, minute: _endTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    var navigator = Routemaster.of(context);

    CurrentUser curUser = GetIt.I.get<CurrentUser>();
    Query$Me$me? heimdallUser = curUser.user;
    User? firebaseUser = auth.currentUser;
    if (heimdallUser == null ||
        heimdallUser.fullContact.private == null ||
        firebaseUser == null) {
      return const ErrorCardWidget(
        errorMessage: 'Er is iets misgegaan met het inloggen',
      );
    }

    Query$Me$me$fullContact$private privateContact =
        heimdallUser.fullContact.private!;
    String creatorName =
        '${privateContact.first_name} ${privateContact.last_name}';

    widget.reservationObject.get().then((obj) {
      if (obj['available'] == false) {
        log('Reservation object is not available');

        return const ErrorCardWidget(
          errorMessage: 'Dit object is gemarkeerd als niet beschikbaar',
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuwe Afschrijving'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: FutureWrapper(
        future:
            reservationsRef // query all afschrijvingen van die dag van die boot
                .where('object', isEqualTo: widget.reservationObject)
                .where('startTime', isGreaterThanOrEqualTo: widget.date)
                .where(
                  'startTime',
                  isLessThanOrEqualTo: widget.date.add(const Duration(days: 1)),
                )
                .get(),
        error: (error) => ErrorCardWidget(errorMessage: error.toString()),
        success: (snapshot) {
          List<QueryDocumentSnapshot<Reservation>> documents = snapshot.docs;

          DateTime earliestPossibleTime = widget.date.add(const Duration(
            hours: 6,
          )); // people can reservate starting at 06:00

          DateTime latestPossibleTime =
              widget.date.add(const Duration(hours: 22));
          for (QueryDocumentSnapshot<Reservation> document in documents) {
            // determine earliest/latest possible time for slider

            Reservation reservation = document.data();
            if ((reservation.startTime.isBefore(_startTime) ||
                    reservation.startTime.isAtSameMomentAs(_startTime)) &&
                reservation.endTime.isAfter(_startTime)) {
              log('Time is not available');
              if (reservation.creator == firebaseUser.uid) {
                return Container();
              }

              return const ErrorCardWidget(
                errorMessage: "Deze tijd is al bezet",
              );
            }

            if ((reservation.endTime.isBefore(_startTime) ||
                    reservation.endTime.isAtSameMomentAs(_startTime)) &&
                reservation.endTime.isAfter(earliestPossibleTime)) {
              earliestPossibleTime = reservation.endTime;
            }

            if ((reservation.startTime.isAfter(_startTime) ||
                    reservation.startTime.isAtSameMomentAs(_startTime)) &&
                reservation.startTime.isBefore(latestPossibleTime)) {
              latestPossibleTime = reservation.startTime;
            }
          }

          if (_endTime.isAfter(latestPossibleTime)) {
            _endTime = latestPossibleTime;
          }
          _startTimeOfDay =
              TimeOfDay(hour: _startTime.hour, minute: _startTime.minute);
          _endTimeOfDay =
              TimeOfDay(hour: _endTime.hour, minute: _endTime.minute);

          const double fieldPadding = 16;
          const double timeSelectorDialogHandlerRadius = 8;

          return ListView(children: <Widget>[
            DataTextListTile(name: 'Boot', value: widget.objectName),
            DataTextListTile(
              name: "Datum",
              value: DateFormat.yMMMMd().format(widget.date),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: DataTextListTile(
                    name: "Starttijd",
                    value: DateFormat.Hm().format(_startTime),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: DataTextListTile(
                    name: "Eindtijd",
                    value: DateFormat.Hm().format(_endTime),
                  ),
                ),
                IconButton(
                  onPressed: () => {
                    showTimeRangePicker(
                      context: context,
                      fromText: 'Starttijd',
                      toText: 'Eindtijd',
                      interval: intervalOfSelector,
                      start: _startTimeOfDay,
                      end: _endTimeOfDay,
                      disabledTime: TimeRange(
                        startTime: TimeOfDay.fromDateTime(latestPossibleTime),
                        endTime: TimeOfDay.fromDateTime(earliestPossibleTime),
                      ),
                      disabledColor: Colors.grey,
                      use24HourFormat: true,
                      handlerRadius: timeSelectorDialogHandlerRadius,
                      minDuration: minimumReservationDuration,
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          _endTimeOfDay = value.endTime;
                          _startTimeOfDay = value.startTime;
                          _endTime = DateTime(
                            widget.date.year,
                            widget.date.month,
                            widget.date.day,
                            _endTimeOfDay.hour,
                            _endTimeOfDay.minute,
                          );
                          _startTime = DateTime(
                            widget.date.year,
                            widget.date.month,
                            widget.date.day,
                            _startTimeOfDay.hour,
                            _startTimeOfDay.minute,
                          );
                        });
                      }
                    }),
                  },
                  icon: Icon(Icons.tune, size: 40),
                  color: Colors.blue,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                createReservationCloud(Reservation(
                  _startTime,
                  _endTime,
                  widget.reservationObject,
                  firebaseUser.uid,
                  widget.objectName,
                  creatorName: creatorName,
                )).then((res) {
                  if (res['success'] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Afschrijving gelukt!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Afschrijving mislukt! ${res['error']}"),
                      ),
                    );
                  }
                  navigator.pop();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
              ),
              child: <Widget>[
                const Icon(LucideIcons.check).padding(bottom: 1),
                const Text('Afschrijven', style: TextStyle(fontSize: 18))
                    .padding(vertical: fieldPadding),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            ).padding(all: fieldPadding),
          ]);
        },
      ),
    );
  }
}

Future<Map<String, dynamic>> createReservationCloud(Reservation r) async {
  try {
    final result = await functions.httpsCallable('createReservation').call({
      'startTime': r.startTime.toUtc().toIso8601String(),
      'endTime': r.endTime.toUtc().toIso8601String(),
      'object': r.reservationObject.path,
      'objectName': r.objectName,
      'creatorName': r.creatorName,
    });

    return result.data;
  } on FirebaseFunctionsException catch (error) {
    return {'success': false, 'error': error.message};
  }
}
