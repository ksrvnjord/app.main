import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_measurement.dart';
import 'package:ksrvnjord_main_app/src/routes/routes.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class CalendarReservation extends StatelessWidget {
  final Map<String, dynamic> data;
  final String reservationDocumentId;

  const CalendarReservation({
    Key? key,
    required this.data,
    required this.reservationDocumentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime startTime = (data['startTime'] as Timestamp).toDate();
    final Duration diffFromEarliestTime = startTime.difference(
      DateTime(
        startTime.year,
        startTime.month,
        startTime.day,
        6,
        0,
        0,
      ), // Reservations start from 6:00.
    );

    /// ----- HEIGHT CALCULATION OF THE RESERVATION BLOCK -----
    // Calculate the duration of the reservation, so we can calculate the height.
    final double durationInMinutes = ((data['endTime'] as Timestamp).seconds -
            (data['startTime'] as Timestamp).seconds) /
        60;
    // Calculate height of reservation block in pixels.
    final double reservationHeight =
        (durationInMinutes / CalendarMeasurement.minutesInSlot) *
            CalendarMeasurement.slotHeight;

    /// ----- Y-POSITION CALCULATION OF THE RESERVATION BLOCK -----
    /// We need to calculate the offset from the top of the column
    /// to the top of the reservation block.

    // Offset of first block, because the column starts before 6:00.
    const double topOffset = CalendarMeasurement.topOffsetFirstSlot;

    // Calculate the height of the block in slots.
    final amountOfSlotsOffset =
        diffFromEarliestTime.inMinutes / CalendarMeasurement.minutesInSlot;
    final double reservationOffset =
        topOffset + (amountOfSlotsOffset * CalendarMeasurement.slotHeight);

    /// ----- OTHER STYLING -----
    const double reservationPadding = 4;

    final colorScheme = Theme.of(context).colorScheme;

    return [
      GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          width: CalendarMeasurement.slotWidth,
          height: reservationHeight,
          child: Text(
            data['creatorName'] ?? 'Afschrijving',
            style: Theme.of(context).textTheme.labelMedium,
          )
              .textColor(colorScheme.onTertiaryContainer)
              .padding(all: reservationPadding),
        ),
        onTap: () => context.pushNamed(
          RouteName.reservation,
          pathParameters: {'id': reservationDocumentId},
        ),
      ),
    ].toColumn().padding(top: reservationOffset);
  }
}
