import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_progress_notifier.dart';
import 'package:routemaster/routemaster.dart';
import '../../shared/model/current_user.dart';
import '../../shared/widgets/error_card_widget.dart';
import '../model/reservation.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:cloud_functions/cloud_functions.dart';

class PlanTrainingPage extends ConsumerStatefulWidget {
  final DocumentReference reservationObject;
  final DateTime startTime;
  final DateTime date;
  final String objectName;

  PlanTrainingPage({Key? key, required Map<String, dynamic> queryParams})
      : reservationObject = FirebaseFirestore.instance
            .collection('reservationObjects')
            .doc(queryParams['reservationObjectId']),
        startTime = DateTime.parse(queryParams['startTime']),
        objectName = queryParams['reservationObjectName'],
        date = DateTime(
          DateTime.parse(queryParams['startTime']).year,
          DateTime.parse(queryParams['startTime']).month,
          DateTime.parse(queryParams['startTime']).day,
        ),
        super(key: key);

  @override
  createState() => _PlanTrainingPageState();
}

class _PlanTrainingPageState extends ConsumerState<PlanTrainingPage> {
  DateTime _startTime = DateTime.now(); // Selected start time of the slider.
  DateTime _endTime = DateTime.now(); // Selected end time of the slider.
  TimeOfDay _startTimeOfDay =
      TimeOfDay.now(); // Selected start time of the slider.
  TimeOfDay _endTimeOfDay = TimeOfDay.now(); // Selected end time of the slider.

  static const intervalOfSelector = Duration(minutes: 15);
  static const minimumReservationDuration = Duration(minutes: 15);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuwe Afschrijving'),
      ),
      body: FutureWrapper(
        future: FirebaseFirestore.instance
            .collection('reservations')
            .withConverter<Reservation>(
              fromFirestore: (snapshot, _) =>
                  Reservation.fromJson(snapshot.data() ?? {}),
              toFirestore: (reservation, _) => reservation.toJson(),
            )
            .where('object', isEqualTo: widget.reservationObject)
            .where('startTime', isGreaterThanOrEqualTo: widget.date)
            .where(
              'startTime',
              isLessThanOrEqualTo: widget.date.add(const Duration(days: 1)),
            )
            .get(),
        success: (snapshot) => renderPage(snapshot),
        error: (error) => ErrorCardWidget(errorMessage: error.toString()),
      ),
    );
  }

  Widget renderPage(
    QuerySnapshot<Reservation> snapshot,
  ) {
    CurrentUser curUser = GetIt.I.get<CurrentUser>();
    final privateContact = curUser.user?.fullContact.private;
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (privateContact == null || firebaseUser == null) {
      return const ErrorCardWidget(
        errorMessage:
            'Er is iets misgegaan met het inloggen, probeer in- en uit te loggen.',
      );
    }

    String creatorName =
        '${privateContact.first_name ?? "Onbekend"} ${privateContact.last_name}';
    const int timeRowItems = 3;
    List<QueryDocumentSnapshot<Reservation>> documents = snapshot.docs;

    DateTime earliestPossibleTime = widget.date.add(const Duration(
      hours: 6,
    )); // People can reservate starting at 06:00.

    DateTime latestPossibleTime = widget.date.add(const Duration(hours: 22));
    for (QueryDocumentSnapshot<Reservation> document in documents) {
      // Determine earliest/latest possible time for slider.
      Reservation reservation = document.data();
      final reservationsHaveSameStartTime =
          reservation.startTime.isAtSameMomentAs(_startTime);

      if ((reservation.startTime.isBefore(_startTime) ||
              reservationsHaveSameStartTime) &&
          reservation.endTime.isAfter(_startTime)) {
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
              reservationsHaveSameStartTime) &&
          reservation.startTime.isBefore(latestPossibleTime)) {
        latestPossibleTime = reservation.startTime;
      }
    }

    if (_endTime.isAfter(latestPossibleTime)) {
      _endTime = latestPossibleTime;
    }
    _startTimeOfDay =
        TimeOfDay(hour: _startTime.hour, minute: _startTime.minute);
    _endTimeOfDay = TimeOfDay(hour: _endTime.hour, minute: _endTime.minute);

    const double fieldPadding = 16;
    const double timeSelectorDialogHandlerRadius = 8;

    final screenWidth = MediaQuery.of(context).size.width;

    return ListView(children: <Widget>[
      DataTextListTile(name: 'Boot', value: widget.objectName),
      DataTextListTile(
        name: "Datum",
        value: DateFormat.MMMMEEEEd('nl_NL').format(widget.date),
      ),
      Row(
        children: [
          SizedBox(
            width: screenWidth / timeRowItems,
            child: DataTextListTile(
              name: "Starttijd",
              value: DateFormat.Hm().format(_startTime),
            ),
          ),
          SizedBox(
            width: screenWidth / timeRowItems,
            child: DataTextListTile(
              name: "Eindtijd",
              value: DateFormat.Hm().format(_endTime),
            ),
          ),
          IconButton(
            onPressed: () => {
              showTimeRangePicker(
                context: context,
                start: _startTimeOfDay,
                end: _endTimeOfDay,
                disabledTime: TimeRange(
                  startTime: TimeOfDay.fromDateTime(latestPossibleTime),
                  endTime: TimeOfDay.fromDateTime(earliestPossibleTime),
                ),
                disabledColor: Colors.grey,
                interval: intervalOfSelector,
                fromText: 'Starttijd',
                toText: 'Eindtijd',
                use24HourFormat: true,
                strokeColor: Colors.lightBlue,
                handlerRadius: timeSelectorDialogHandlerRadius,
                // ignore: no-equal-arguments
                handlerColor: Colors.lightBlue,
                minDuration: minimumReservationDuration,
              ).then((value) {
                if (value != null && mounted) {
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
            icon: const Icon(Icons.tune, size: 40),
          ),
        ],
      ),
      buildReservationButton(
        firebaseUser,
        creatorName,
        fieldPadding,
      ).padding(all: fieldPadding),
    ]);
  }

  ElevatedButton buildReservationButton(
    User firebaseUser,
    String creatorName,
    double fieldPadding,
  ) {
    final reservationIsInProgress = ref.watch(reservationProgressProvider);

    return ElevatedButton(
      onPressed: reservationIsInProgress
          ? null
          : () => createReservation(
                firebaseUser.uid,
                creatorName,
              ),
      child: <Widget>[
        Icon(reservationIsInProgress ? LucideIcons.loader : LucideIcons.check)
            .padding(bottom: 1),
        Text(
          reservationIsInProgress ? "Zwanen voeren..." : 'Afschrijven',
          style: const TextStyle(fontSize: 18),
        ).padding(vertical: fieldPadding),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    );
  }

  void createReservation(
    String uid,
    String creatorName,
  ) async {
    ref.read(reservationProgressProvider.notifier).inProgress();
    final response = await createReservationCloud(Reservation(
      _startTime,
      _endTime,
      widget.reservationObject,
      uid,
      widget.objectName,
      creatorName: creatorName,
      createdAt: DateTime.now(),
    ));

    if (response['success'] == true) {
      FirebaseAnalytics.instance.logEvent(
        name: 'reservation_created',
        parameters: <String, dynamic>{
          'reservation_object_name': widget.objectName,
        },
      );
      // ignore: avoid-ignoring-return-values, use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Afschrijving gelukt!'),
          backgroundColor: Colors.green,
          showCloseIcon: true,
        ),
      );
    } else {
      // ignore: avoid-ignoring-return-values, use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Afschrijving mislukt! ${response['error']}"),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ),
      );
    }
    ref.read(reservationProgressProvider.notifier).done();
    // ignore: avoid-ignoring-return-values, use_build_context_synchronously
    Routemaster.of(context).pop();
  }

  Future<Map<String, dynamic>> createReservationCloud(Reservation r) async {
    try {
      final result = await FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('createReservation')
          .call({
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
}
