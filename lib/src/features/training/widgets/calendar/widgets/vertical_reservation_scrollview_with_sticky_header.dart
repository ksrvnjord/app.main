import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/object_calendar.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/reservation_object_name_box.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:styled_widget/styled_widget.dart';

class VerticalReservationScrollViewWithStickyHeader extends StatelessWidget {
  const VerticalReservationScrollViewWithStickyHeader({
    super.key,
    required this.boatsController,
    required this.date,
    required this.snapshot,
  });

  final ScrollController boatsController;
  final DateTime date;
  final QuerySnapshot<ReservationObject> snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: boatsController,
      child: Padding(
        padding: const EdgeInsets.only(left: 64),
        child: StickyHeader(
          header: snapshot.docs // this builds the header with the boat names
              .map<Widget>(
                (doc) => ReservationObjectNameBox(reservationObj: doc),
              )
              .toList()
              .toRow(),
          content: snapshot.docs // this builds the content with the slots
              .map<Widget>((e) {
                return ObjectCalendar(date: date, boat: e).border(
                  left: 1,
                  color: const Color.fromARGB(255, 223, 223, 223),
                );
              })
              .toList()
              .toRow(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
        ),
      ),
    );
  }
}
