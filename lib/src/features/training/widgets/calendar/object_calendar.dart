import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
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

    bool needToReturn = false;

    // Check the permissions of the current user
    // 1: Get the ID token that contains the permission claims
    FirebaseAuth.instance.currentUser?.getIdTokenResult().then((token) {
      // 2: Check if the boat permissions are empty
      if (boatData.permissions.isNotEmpty &&
          // If not, 3: convert permissions to a set,
          // get the permissions from the token
          // and see if there is any overlap
          boatData.permissions
              .toSet()
              .intersection((token.claims?['permissions'] ?? []).toSet())
              .isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Je hebt geen permissies voor dit object.'),
        ));
        needToReturn = true;
      }
    });

    if (needToReturn) {
      return;
    }

    // Take the local position, starting at 6 and divide it into
    // hour blocks of 64px
    final double location = 6 + ((details.localPosition.dy - 16) / 64);
    // Double the local position, round it, and divide it by two
    // to get the half-hourly-precise start position
    final double timeDouble = (location * 2).floor() / 2;
    // Calculate startTime
    final DateTime time = DateTime(
      date.year,
      date.month,
      date.day,
      // Get the whole hour
      min(21, max(6, (timeDouble).floor())),
      // Get the decimal (12.5 -> .5),
      // calculate the minute (.5 -> 30),
      // and round to integer
      ((timeDouble % 1) * 60).round(),
    );

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
    DateTime nowStart = DateTime(date.year, date.month, date.day, 6, 0, 0);
    DateTime nowEnd = DateTime(date.year, date.month, date.day, 22, 0, 0);

    // Get all reservations within that time period
    final reservations = reservationRef
        .where('object', isEqualTo: boat.reference)
        .where('startTime', isGreaterThanOrEqualTo: nowStart)
        .where('startTime', isLessThanOrEqualTo: nowEnd)
        .get(const GetOptions(source: Source.serverAndCache));

    const double calendarSlotWidth = 128;

    return SizedBox(
      width: calendarSlotWidth,
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
            child: const AbsorbPointer(
              child: CalendarBackground(),
            ),
          ),
          // Wrap the reservations
          FutureWrapper(
            future: reservations,
            // Shimmer entire screen on loading
            loading: const ShimmerWidget(
              child: SizedBox(height: 32 * 32, width: 128),
            ),
            // Create a stack of the resulting reservations
            success: (reservations) {
              return reservations.docs
                  .map((reservation) {
                    return CalendarReservation(
                      data: reservation.data().toJson(),
                      id: reservation.id,
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
