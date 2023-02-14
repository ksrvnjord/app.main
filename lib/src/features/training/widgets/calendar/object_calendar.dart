import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_measurement.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/calendar_background.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/calendar_reservation.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../model/reservation.dart';

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
  // Date is passed by parent
  late DateTime date;
  // Boat is passed by parent
  late QueryDocumentSnapshot<ReservationObject> boat;
  late DateTime? reservation;
  bool hasPermission = false;

  // Create reference for query
  CollectionReference<Reservation> reservationRef = FirebaseFirestore.instance
      .collection('reservations')
      .withConverter<Reservation>(
        fromFirestore: (snapshot, _) => Reservation.fromJson(snapshot.data()!),
        toFirestore: (reservation, _) => reservation.toJson(),
      );

  // Get current time
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    date = widget.date;
    boat = widget.boat;
    reservation = null;
    checkPermission();
  }

  // Checks if the current user has permissions to
  // reserve this boat, runs once in initState
  void checkPermission() {
    // 1: Get the ID token that contains the permission claims
    FirebaseAuth.instance.currentUser?.getIdTokenResult().then((token) {
      // 2: Check if the boat permissions are empty
      if (boat.data().permissions.isEmpty ||
          // If not, 3: convert permissions to a set,
          // get the permissions from the token
          // and see if there is any overlap
          boat
              .data()
              .permissions
              .toSet()
              .intersection((token.claims?['permissions'] ?? []).toSet())
              .isNotEmpty) {
        setState(() {
          hasPermission = true;
        });
      }
    });
  }

  void handleTap(TapUpDetails details) {
    final boatData = boat.data();

    // Check if the boat is in-de-vaart
    if (!boatData.available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dit object is uit de vaart.')),
      );

      return;
    }

    // Re-check the permission
    checkPermission();

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Je hebt geen permissies voor dit object.'),
      ));

      return;
    }

    /// ---- Calculate the time the user tapped ----

    // This is the position relative to the RenderBox.
    final double tapLocationAbsoluteY = details.localPosition.dy;

    // This is the position relative to the top of the first slot.
    final double tapLocationRelativeY =
        tapLocationAbsoluteY - CalendarMeasurement.topOffsetFirstSlot;

    // Now we need to calculate in which slot the user tapped.
    // We do this by dividing the relative position by the slot height.
    // This gives us the slot number (indexed from 0), but we need to round it to the nearest
    // integer.
    final int slotNumber =
        tapLocationRelativeY ~/ CalendarMeasurement.slotHeight;

    // Now we can calculate the offset in minutes from the start
    final int offsetMinutes = slotNumber * 30;

    // Add offsetMinutes to 6:00 to get the time the user tapped
    DateTime time = DateTime(date.year, date.month, date.day, 6, 0, 0)
        .add(Duration(minutes: offsetMinutes));

    Routemaster.of(context)
        .push('plan', queryParameters: {
          'reservationObjectId': boat.id,
          'reservationObjectName': boat.get('name'),
          'startTime': time.toIso8601String(),
        })
        .result
        .then((value) => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    // Calculate start and end of day
    DateTime nowStart = DateTime(
      date.year,
      date.month,
      date.day,
      CalendarMeasurement.startHour,
      0,
      0,
    );
    DateTime nowEnd = DateTime(
        date.year, date.month, date.day, CalendarMeasurement.endHour, 0, 0);

    // Get all reservations within that time period
    final reservations = reservationRef
        .where('object', isEqualTo: boat.reference)
        .where('startTime', isGreaterThanOrEqualTo: nowStart)
        .where('startTime', isLessThanOrEqualTo: nowEnd)
        .get(const GetOptions(source: Source.serverAndCache));

    return SizedBox(
      width: CalendarMeasurement.slotWidth,
      // Stack the elements over eachother
      child: Stack(
        children: [
          // Horizontal bars of 32h, that are tappable
          // to make new reservations
          GestureDetector(
            // Handle the taps with a defined function
            onTapUp: handleTap,
            // Wrap the background in an AbsorbPointer, so that
            // it does not pass gestures through to the background
            child: AbsorbPointer(
              child: CalendarBackground(
                available: (hasPermission && boat.data().available),
              ),
            ),
          ),
          // Wrap the reservations
          FutureWrapper(
            future: reservations,
            // Shimmer entire screen on loading
            loading: const ShimmerWidget(
              child: SizedBox(
                height: CalendarMeasurement.slotHeight *
                    CalendarMeasurement.amountOfSlots,
                width: CalendarMeasurement.slotWidth,
              ),
            ),
            // Create a stack of the resulting reservations
            success: (reservations) {
              return reservations.docs
                  .map((reservation) {
                    return CalendarReservation(
                      data: reservation.data().toJson(),
                      reservationDocumentId: reservation.id,
                    );
                  })
                  .toList()
                  .toStack();
            },
          ),
        ],
      ),
    );
  }
}
