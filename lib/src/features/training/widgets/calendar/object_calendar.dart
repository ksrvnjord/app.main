import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/shimmer_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/calendar_background.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/calendar_reservation.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_measurement.dart';

import 'api/reservations_for_object_provider.dart';
import 'model/reservations_query.dart';

class ObjectCalendar extends ConsumerStatefulWidget {
  final DateTime date;
  final QueryDocumentSnapshot<ReservationObject> boat;
  const ObjectCalendar({
    Key? key,
    required this.date,
    required this.boat,
  }) : super(key: key);

  @override
  createState() => _ObjectCalendar();
}

class _ObjectCalendar extends ConsumerState<ObjectCalendar> {
  // Date is passed by parent
  late DateTime? reservation;
  bool hasPermission = false;
  late ReservationsQuery reservationsQuery;

  @override
  void initState() {
    super.initState();
    reservation = null;
    reservationsQuery = ReservationsQuery(widget.date, widget.boat.reference);
    checkPermission();
  }

  // Checks if the current user has permissions to
  // reserve this boat, runs once in initState
  void checkPermission() {
    // 1: Get the ID token that contains the permission claims
    FirebaseAuth.instance.currentUser?.getIdTokenResult().then((token) {
      // 2: Check if the boat permissions are empty
      final permissions = widget.boat.data().permissions;
      if (permissions.isEmpty ||
          // If not, 3: convert permissions to a set,
          // get the permissions from the token
          // and see if there is any overlap
          permissions
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
    final boatData = widget.boat.data();

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

    if (boatData.critical) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Dit object is uit de vaart.'),
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
    DateTime time =
        DateTime(widget.date.year, widget.date.month, widget.date.day, 6, 0, 0)
            .add(Duration(minutes: offsetMinutes));

    // TODO: calculate here from when till when the user can make a reservation

    Routemaster.of(context).push('plan', queryParameters: {
      'reservationObjectId': widget.boat.id,
      'reservationObjectName': widget.boat.get('name'),
      'startTime': time.toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservations = ref.watch(reservationsProvider(
      reservationsQuery,
    ));

    final boat = widget.boat.data();

    return SizedBox(
      width: CalendarMeasurement.slotWidth,
      // Stack the elements over eachother
      child: Stack(
        children: [
          // Horizontal bars of 32h, that are tappable
          // to make new reservations
          GestureDetector(
              child: AbsorbPointer(
                  child: CalendarBackground(
                      available:
                          (hasPermission && boat.available) && !boat.critical)),
              onTapUp: handleTap),
          // Wrap the reservations
          reservations.when(
            // Shimmer entire screen on loading
            loading: () => const ShimmerWidget(
              child: SizedBox(
                  width: CalendarMeasurement.slotWidth,
                  height: CalendarMeasurement.slotHeight *
                      CalendarMeasurement.amountOfSlots),
            ),
            // Create a stack of the resulting reservations
            data: (reservations) {
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
            error: (error, stackTrace) =>
                ErrorCardWidget(errorMessage: error.toString()),
          ),
          Positioned(
              left: 0,
              top: CalendarMeasurement.amountOfPixelsTill1726FromTop() - 1,
              child: Row(children: [
                for (int i = 0;
                    i <
                        CalendarMeasurement.slotWidth ~/
                            CalendarMeasurement.stripeWidth1726;
                    i++)
                  Container(
                      color: i % 2 == 0
                          ? const Color(0x6011436d)
                          : Colors.transparent,
                      width: CalendarMeasurement.stripeWidth1726,
                      height: 2)
              ])),
        ],
      ),
    );
  }
}
