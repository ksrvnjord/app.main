import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/api/reservations_for_object_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/model/reservations_query.dart';
import '../../shared/widgets/error_card_widget.dart';
import '../model/reservation.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:cloud_functions/cloud_functions.dart';

class PlanTrainingPage extends ConsumerStatefulWidget {
  PlanTrainingPage({
    super.key,
    required this.reservationObject,
    required this.startTime,
    required this.objectName,
  }) : date = DateTime(
          startTime.year,
          startTime.month,
          startTime.day,
        );

  final DocumentReference<ReservationObject> reservationObject;
  final DateTime startTime;
  final DateTime date;
  final String objectName;

  @override
  createState() => _PlanTrainingPageState();
}

class _PlanTrainingPageState extends ConsumerState<PlanTrainingPage> {
  DateTime _startTime = DateTime.now(); // Selected start time of the slider.
  DateTime _endTime = DateTime.now(); // Selected end time of the slider.

  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime;
    _endTime = widget.startTime.add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);

    final reservationsVal = ref.watch(reservationsProvider(
      ReservationsQuery(widget.date, widget.reservationObject),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuwe Afschrijving'),
      ),
      body: inProgress
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : reservationsVal.when(
              data: (snapshot) => renderPage(snapshot, user),
              loading: () =>
                  const CircularProgressIndicator.adaptive().center(),
              error: (error, stk) =>
                  ErrorCardWidget(errorMessage: error.toString()),
            ),
    );
  }

  /// Finds the available time range for a reservation.
  ///
  /// This function iterates over all existing reservations in the provided [snapshot]
  /// and determines the earliest and latest possible times for a new reservation.
  ///
  /// The earliest possible time for a reservation is the end time of the last reservation
  /// that ends before the start time of the new reservation.
  ///
  /// The latest possible time for a reservation is the start time of the first reservation
  /// that starts after the start time of the new reservation.
  ///
  /// If a user already has a reservation at the start time of the new reservation,
  /// an exception is thrown.
  ///
  /// If the start time of the new reservation is during another reservation,
  /// an exception is thrown.
  ///
  /// @param snapshot The [QuerySnapshot] of existing reservations.
  /// @return A [DateTimeRange] representing the available time range for a new reservation.
  // ignore: prefer-named-parameters
  DateTimeRange findAvailableTimerange(
    QuerySnapshot<Reservation> snapshot,
    DateTime desiredStartTime,
  ) {
    final user = ref.watch(currentUserNotifierProvider);
    if (user == null) {
      throw Exception(
        "Er is iets misgegaan met het ophalen van je gegevens, "
        "probeer opnieuw in te loggen.",
      );
    }

    DateTime earliestPossibleTime = widget.date.add(const Duration(
      hours: 6,
    )); // People can reservate starting at 06:00.

    DateTime latestPossibleTime = widget.date.add(const Duration(hours: 22));
    for (QueryDocumentSnapshot<Reservation> document in snapshot.docs) {
      // Determine earliest/latest possible time for slider.
      Reservation reservation = document.data();
      final reservationsHaveSameStartTime =
          reservation.startTime.isAtSameMomentAs(desiredStartTime);

      if ((reservation.startTime.isBefore(desiredStartTime) ||
              reservationsHaveSameStartTime) &&
          reservation.endTime.isAfter(desiredStartTime)) {
        if (reservation.creatorId == user.identifier.toString()) {
          throw Exception(
            "Je hebt al een afschrijving op dit tijdstip, je kan niet twee keer achter elkaar afschrijven",
          );
        }
        throw Exception(
          "Dit tijdstip is al bezet door ${reservation.creatorName}",
        );
      }

      if ((reservation.endTime.isBefore(desiredStartTime) ||
              reservation.endTime.isAtSameMomentAs(desiredStartTime)) &&
          reservation.endTime.isAfter(earliestPossibleTime)) {
        earliestPossibleTime = reservation.endTime;
      }

      if ((reservation.startTime.isAfter(desiredStartTime) ||
              reservationsHaveSameStartTime) &&
          reservation.startTime.isBefore(latestPossibleTime)) {
        latestPossibleTime = reservation.startTime;
      }
    }

    return DateTimeRange(start: earliestPossibleTime, end: latestPossibleTime);
  }

  // TODO: Extract method.
  // ignore: avoid-long-functions
  Widget renderPage(QuerySnapshot<Reservation> snapshot, User? currentUser) {
    if (currentUser == null) {
      return const ErrorCardWidget(
        errorMessage: "Er is iets misgegaan met het ophalen van je gegevens, "
            "probeer opnieuw in te loggen.",
      );
    }

    const int timeRowItems = 3;

    try {
      final range = findAvailableTimerange(snapshot, _startTime);
      final (earliestPossibleTime, latestPossibleTime) =
          (range.start, range.end);

      if (_endTime.isAfter(latestPossibleTime)) {
        _endTime = latestPossibleTime;
      }

      const double fieldPadding = 16;
      const double timeSelectorDialogHandlerRadius = 8;

      final screenWidth = MediaQuery.of(context).size.width;
      const intervalOfSelector = Duration(minutes: 15);
      const minimumReservationDuration = Duration(minutes: 15);

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
                  start: TimeOfDay(
                    hour: _startTime.hour,
                    minute: _startTime.minute,
                  ),
                  end: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
                  disabledTime: TimeRange(
                    startTime: TimeOfDay.fromDateTime(latestPossibleTime),
                    endTime: TimeOfDay.fromDateTime(earliestPossibleTime),
                  ),
                  disabledColor: Colors.grey,
                  interval: intervalOfSelector,
                  fromText: 'Starttijd',
                  toText: 'Eindtijd',
                  strokeColor: Colors.lightBlue,
                  handlerRadius: timeSelectorDialogHandlerRadius,
                  // ignore: no-equal-arguments
                  handlerColor: Colors.lightBlue,
                  minDuration: minimumReservationDuration,
                ).then((value) {
                  // Value is an Object? with properties: startTime, endTime.
                  if (value == null || !mounted) return;

                  final (startTimeOfDay, endTimeOfDay) = (
                    value.startTime as TimeOfDay,
                    value.endTime as TimeOfDay
                  );
                  setState(() {
                    _endTime = DateTime(
                      widget.date.year,
                      widget.date.month,
                      widget.date.day,
                      endTimeOfDay.hour,
                      endTimeOfDay.minute,
                    );
                    _startTime = DateTime(
                      widget.date.year,
                      widget.date.month,
                      widget.date.day,
                      startTimeOfDay.hour,
                      startTimeOfDay.minute,
                    );
                  });
                }),
              },
              icon: const Icon(Icons.tune, size: 40),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: inProgress
              ? null
              : () => createReservation(
                    currentUser.identifier.toString(),
                    currentUser.fullName,
                  ),
          child: <Widget>[
            Icon(inProgress ? LucideIcons.loader : LucideIcons.check)
                .padding(bottom: 1),
            Text(
              inProgress ? "Zwanen voeren..." : 'Afschrijven',
              style: const TextStyle(fontSize: 18),
            ).padding(vertical: fieldPadding),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        ).padding(all: fieldPadding),
      ]);
    } catch (e) {
      return ErrorCardWidget(errorMessage: e.toString());
    }
  }

  void createReservation(
    String uid,
    String creatorName,
  ) async {
    setState(() {
      inProgress = true;
    });

    final res = await createReservationCloud(Reservation(
      startTimestamp: Timestamp.fromDate(_startTime),
      endTimestamp: Timestamp.fromDate(_endTime),
      reservationObject: widget.reservationObject,
      creatorId: uid,
      objectName: widget.objectName,
      creatorName: creatorName,
    ));

    if (res['success'] == true) {
      FirebaseAnalytics.instance.logEvent(
        name: 'reservation_created',
        parameters: <String, dynamic>{
          'reservation_object_name': widget.objectName,
        },
      );
      if (!context.mounted) return;
      if (mounted) {
        // ignore: avoid-ignoring-return-values, use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Afschrijving gelukt!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (!context.mounted) return;

      if (mounted) {
        final colorScheme = Theme.of(context).colorScheme;
        // ignore: avoid-ignoring-return-values, use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Afschrijving mislukt! ${res['error']}",
            ).textColor(colorScheme.onErrorContainer),
            backgroundColor: colorScheme.errorContainer,
          ),
        );
      }
    }
    if (mounted) {
      // ignore: avoid-ignoring-return-values, use_build_context_synchronously
      context.pop();
    }
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
