import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    DateTime timestamp = (data['startTime'] as Timestamp).toDate();
    Duration differenceFromEarliestTime = timestamp.difference(
      DateTime(timestamp.year, timestamp.month, timestamp.day, 6, 0, 0),
    );

    // Calculate the duration of the reservation
    double durationInHours = ((data['endTime'] as Timestamp).seconds -
            (data['startTime'] as Timestamp).seconds) /
        3600;

    final navigator = Routemaster.of(context);

    const double reservationWidth = 128;
    const double slotHeight = 32;
    const double slotHeightModifier = 2; // 2 slots per hour

    const double reservationPadding = 4;

    const double topOffset = 16; // the first time slot is 16px from the top
    const double minutesInSlot = 30;
    const double amountOfSlots = 32;
    final double reservationOffset =
        (differenceFromEarliestTime.inMinutes / minutesInSlot) * amountOfSlots;

    return [
      GestureDetector(
        onTap: () => navigator.push(reservationDocumentId),
        child: Container(
          width: reservationWidth,
          height: durationInHours * slotHeight * slotHeightModifier,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Text(
            data['creatorName'] ?? 'Afschrijving',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ).padding(all: reservationPadding),
        ),
      ),
    ].toColumn().padding(top: topOffset + reservationOffset);
  }
}
