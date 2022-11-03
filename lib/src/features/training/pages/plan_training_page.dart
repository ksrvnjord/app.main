import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:ksrvnjord_main_app/src/features/training/pages/training_page.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// HELP: What to do with these 'constants'. Maybe make a separate file to store them?
FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference<Reservation> reservationsRef = db
    .collection('reservations')
    .withConverter<Reservation>(
      fromFirestore: (snapshot, _) => Reservation.fromJson(snapshot.data()!),
      toFirestore: (reservation, _) => reservation.toJson(),
    );

class PlanTrainingPage extends StatefulWidget {
  final DocumentReference reservationObject;
  final DateTime startTime;
  late final DateTime date;

  PlanTrainingPage({Key? key, required Map<String, dynamic> queryParams})
      : reservationObject = db
            .collection('reservationObjects')
            .doc(queryParams['reservationObjectId']),
        startTime = DateTime.parse(queryParams['startTime']),
        super(key: key) {
    date = DateTime(startTime.year, startTime.month, startTime.day);
  }

  @override
  State<PlanTrainingPage> createState() => _PlanTrainingPageState();
}

class _PlanTrainingPageState extends State<PlanTrainingPage> {
  late DateTime _startTime; // Selected start time of the slider
  late DateTime _endTime; // Selected end time of the slider

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime;
    _endTime = widget.startTime.add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
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
          DateTime earliestPossibleTime = widget.date.add(const Duration(
              hours: 6)); // people can reservate starting at 06:00

          DateTime latestPossibleTime =
              widget.date.add(const Duration(hours: 22));
          for (QueryDocumentSnapshot<Reservation> document in data.docs) {
            // determine earliest/latest possible time for slider

            Reservation reservation = document.data();
            // TODO: add error handling if initial starttime is within range of another reservaiton -> send to previous page

            if ((reservation.startTime.isBefore(_startTime) || reservation.startTime.isAtSameMomentAs(_startTime)) &&
                reservation.endTime.isAfter(_startTime)) {
              // overlaps
              throw Exception(
                  "A time was chosen that overlaps with another reservation of this object.");
            }

            if ((reservation.endTime.isBefore(_startTime) || reservation.endTime.isAtSameMomentAs(_startTime)) &&
                reservation.endTime.isAfter(earliestPossibleTime)) {
              earliestPossibleTime = reservation.endTime;
            }

            if ((reservation.startTime.isAfter(_startTime) || reservation.startTime.isAtSameMomentAs(_startTime)) &&
                reservation.startTime.isBefore(latestPossibleTime)) {
              latestPossibleTime = reservation.startTime;
            }

          }

          if (_endTime.isAfter(latestPossibleTime)) {
            _endTime = latestPossibleTime;
          }
          // bepaal laatste eindtijd die voor de starttijd ligt
          // bepaal eerste starttijd die na de eindtijd ligt
          Duration range = latestPossibleTime.difference(earliestPossibleTime);
          print("earliest possible time: $earliestPossibleTime");
          print("latest possible time: $latestPossibleTime");
          Reservation newReservation;
          return <Widget>[
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Afschrijven',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.reservationObject.id,
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
            SingleChildScrollView(
              controller: ScrollController(
                initialScrollOffset: _startTime
                        .difference(earliestPossibleTime)
                        .inMinutes
                        .toDouble() *
                    3,
              ),
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width * (range.inMinutes / 120),
                height: 140,
                child: SfRangeSlider(
                  min: earliestPossibleTime,
                  max: latestPossibleTime,
                  values: SfRangeValues(_startTime, _endTime),
                  dragMode: SliderDragMode.both,
                  showTicks: true,
                  showLabels: true,
                  enableTooltip: true,
                  shouldAlwaysShowTooltip: true,
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
                ),
              ),
            ),
            ElevatedButton(
                    onPressed: () => {
                          newReservation = Reservation(_startTime, _endTime,
                              widget.reservationObject, 21203),
                          newReservation.createdAt = DateTime.now(),
                          createReservation(newReservation),
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  const TrainingPage())), // Training page is refreshed by not using RouteMaster
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

void createReservation(Reservation r) async {
  DateTime startDate =
      DateTime(r.startTime.year, r.startTime.month, r.startTime.day);
  db
      .runTransaction((transaction) async {
        // Get the document
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
        await reservationsRef
            .add(r)
            // ignore: avoid_print
            .then((value) => print("Afschrijving Added"))
            // ignore: avoid_print
            .catchError((error) => print(
                "Firestore can't add the reservation at this moment: $error"));
      }, maxAttempts: 1) // only try once
      // ignore: avoid_print
      .then((value) => print("Transaction completed: Added reservation"))
      // ignore: avoid_print
      .catchError((error) =>
          print("Transaction failed: Did not add reservation : $error"));
}
