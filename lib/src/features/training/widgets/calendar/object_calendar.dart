import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/slots.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/calendar_background.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/calendar_reservation.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_widget/styled_widget.dart';

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

  // Create reference for query
  CollectionReference reservationRef =
      FirebaseFirestore.instance.collection('reservations');

  // Get current time
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    date = widget.date;
    boat = widget.boat;
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

    return SizedBox(
        width: 96,
        // Stack the elements over eachother
        child: Stack(
          children: [
            // Horizontal bars of 32h
            const CalendarBackground(fragmentHeight: 32),
            // Wrap the reservations
            FutureWrapper(
                future: reservations,
                // Shimmer entire screen on loading
                loading: const ShimmerWidget(
                    child: SizedBox(height: 32 * 32, width: 96)),
                // Create a stack of the resulting reservations
                success: (reservations) {
                  if (reservations != null) {
                    return reservations.docs
                        .map((reservation) {
                          return CalendarReservation(
                              fragmentHeight: 32,
                              data: reservation.data(),
                              id: reservation.id);
                        })
                        .toList()
                        .toStack();
                  }
                  // Or just return an empty container if it fails
                  return Container();
                })
          ],
        ));
  }
}
