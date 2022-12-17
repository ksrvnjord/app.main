import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:routemaster/routemaster.dart';
import '../../shared/model/current_user.dart';
import '../../shared/widgets/error.dart';
import '../model/reservation.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_range_picker/time_range_picker.dart';


// HELP: What to do with these 'constants'. Maybe make a separate file to store them?
FirebaseFirestore db = FirebaseFirestore.instance;
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

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime;
    _endTime = widget.startTime.add(const Duration(hours: 1));
    _startTimeOfDay = TimeOfDay(hour: _startTime.hour, minute: _startTime.minute);  
    _endTimeOfDay = TimeOfDay(hour: _endTime.hour, minute: _endTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    var navigator = Routemaster.of(context);

    var cur_user = GetIt.I.get<CurrentUser>();
    var contact = cur_user.user!.fullContact.public;
    String first_name = contact.first_name!;
    String last_name = contact.last_name!;

    widget.reservationObject.get().then((obj) {
      if (obj['available'] == false) {
        log('Reservation object is not available');
        return const ErrorCardWidget(
            errorMessage: 'Dit object is gemarkeerd als niet beschikbaar');
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
      body: StreamBuilder<QuerySnapshot<Reservation>>(
        stream:
            reservationsRef // query all afschrijvingen van die dag van die boot
                .where('object', isEqualTo: widget.reservationObject)
                .where('startTime', isGreaterThanOrEqualTo: widget.date)
                .where('startTime',
                    isLessThanOrEqualTo:
                        widget.date.add(const Duration(days: 1)))
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return const ErrorCardWidget(
                errorMessage:
                    "We konden de afschrijvingen niet ophalen van de server");
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          DateTime earliestPossibleTime = widget.date.add(const Duration(
              hours: 6)); // people can reservate starting at 06:00

          DateTime latestPossibleTime =
              widget.date.add(const Duration(hours: 22));
          for (QueryDocumentSnapshot<Reservation> document in data.docs) {
            // determine earliest/latest possible time for slider

            Reservation reservation = document.data();
            if ((reservation.startTime.isBefore(_startTime) || reservation.startTime.isAtSameMomentAs(_startTime)) &&
                reservation.endTime.isAfter(_startTime)) {
              log('Time is not available');
              return const ErrorCardWidget(
                  errorMessage: "Deze tijd is al bezet");
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
          _startTimeOfDay = TimeOfDay(hour: _startTime.hour, minute: _startTime.minute);
          _endTimeOfDay = TimeOfDay(hour: _endTime.hour, minute: _endTime.minute);
          return <Widget>[
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Afschrijven',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.objectName,
              style: const TextStyle(color: Colors.black54),
            ).padding(all: 15),
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Dag',
                border: OutlineInputBorder(),
              ),
              initialValue: DateFormat.yMMMMd().format(widget.date),
              style: const TextStyle(color: Colors.black54),
            ).padding(all: 15),
            // show text "Jouw trainingstijden" emphasize that this is the time
            // the user selected
            Text(
              'Jouw afschrijftijden',
              style: Theme.of(context).textTheme.headline6,
            ).padding(all: 15),
            // show selected start and end time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  DateFormat.Hm().format(_startTime),
                  style: const TextStyle(fontSize: 20),
                ),
                const Icon(Icons.arrow_forward),
                Text(
                  DateFormat.Hm().format(_endTime),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ).padding(all: 15),

            // show button to let user change start and end time
            ElevatedButton(
              onPressed: () {
                showTimeRangePicker(
                  context: context,
                  fromText: 'Starttijd',
                  toText: 'Eindtijd',
                  interval: const Duration(minutes: 30),
                  start: _startTimeOfDay,
                  end: _endTimeOfDay,
                  disabledTime: TimeRange(startTime: TimeOfDay.fromDateTime(latestPossibleTime), endTime: TimeOfDay.fromDateTime(earliestPossibleTime)),
                  disabledColor: Colors.grey,
                  use24HourFormat: true,
                  handlerRadius: 8,
                  minDuration: const Duration(minutes: 30),
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
                          _endTimeOfDay.minute);
                      _startTime = DateTime(
                          widget.date.year,
                          widget.date.month,
                          widget.date.day,
                          _startTimeOfDay.hour,
                          _startTimeOfDay.minute);
                    });
                  }
                });
              },
              child: const Text("Wijzig tijden"),
            ).padding(all: 15),
            ElevatedButton(
                    onPressed: () {
                      Future<bool> res = createReservation(Reservation(
                          _startTime,
                          _endTime,
                          widget.reservationObject,
                          FirebaseAuth.instance.currentUser!.uid,
                          widget.objectName,
                          creatorName: "$first_name $last_name",
                          ));
                      navigator.pop(
                          res); // let the parent know if reloading is needed because of a new reservation
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue),
                    child: <Widget>[
                      const Icon(LucideIcons.check).padding(bottom: 1),
                      const Text('Afschrijven', style: TextStyle(fontSize: 18))
                          .padding(vertical: 16)
                    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween))
                .padding(all: 16)
          ].toColumn().padding(all: 16);
        },
      ),
    );
  }
}

Future<bool> createReservation(Reservation r) async {
  DateTime startDate =
      DateTime(r.startTime.year, r.startTime.month, r.startTime.day);
  bool result = await db
      .runTransaction((transaction) async {
        // Get the document

        DocumentSnapshot<ReservationObject> reservationObjectSnapshot = await r
            .reservationObject
            .withConverter<ReservationObject>(
                fromFirestore: (snapshot, _) =>
                    ReservationObject.fromJson(snapshot.data()!),
                toFirestore: (obj, _) => obj.toJson())
            .get();

        // Check if object is available for bookings
        ReservationObject reservationObject = reservationObjectSnapshot.data()!;
        if (!reservationObject.available) {
          throw Exception(
              "Het object dat je wilde reserveren is niet beschikbaar");
        }

        QuerySnapshot<Reservation> reservations = await reservationsRef
            .where('object', isEqualTo: r.reservationObject)
            .where('startTime', isGreaterThanOrEqualTo: startDate)
            .where('startTime',
                isLessThanOrEqualTo: startDate.add(const Duration(days: 1)))
            .get();

        // check for overlap of current reservation with existing reservations
        for (QueryDocumentSnapshot<Reservation> document in reservations.docs) {
          Reservation reservation = document.data();
          if (reservation.startTime.isBefore(r.endTime) &&
              reservation.endTime.isAfter(r.startTime)) {
            throw Exception('Er is al een reservering op die tijd');
          }
        }
        r.createdAt = DateTime.now();
        await reservationsRef
            .add(r)
            .then((value) => log("Afschrijving Added Succesfully to Firestore"))
            .catchError((error) {
          throw Exception(
              "Firestore can't add the reservation at this moment: $error");
        });
      }, maxAttempts: 1) // only try once
      .then((value) => true)
      .catchError((error) => false);
  return result;
}
