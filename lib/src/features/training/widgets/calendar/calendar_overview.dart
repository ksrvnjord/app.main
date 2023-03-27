import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_type_filters_notifier.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/time_scrollview.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/widgets/vertical_reservation_scrollview_with_sticky_header.dart';
import 'package:styled_widget/styled_widget.dart';

// Shows all available objects for a given day and filters
class CalendarOverview extends ConsumerStatefulWidget {
  final DateTime date;

  const CalendarOverview({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  createState() => _CalendarOverview();
}

class _CalendarOverview extends ConsumerState<CalendarOverview> {
  late final ScrollController boatsController;
  late final ScrollController timesController;

  @override
  void dispose() {
    boatsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    boatsController = ScrollController();
    timesController = ScrollController();

    boatsController.addListener(() {
      if (boatsController.offset != timesController.offset) {
        timesController.jumpTo(boatsController.offset);
      }
    }); // this makes the time column scroll with the boats

    super.initState();
  }

  static const double iconPadding = 8;

  @override
  Widget build(BuildContext context) {
    final List<String> filters = ref.watch(reservationTypeFiltersListProvider);

    if (filters.isEmpty) {
      return <Widget>[
        const Icon(Icons.waves, color: Colors.blueGrey)
            .padding(all: iconPadding),
        const Text(
          'Selecteer een categorie om te beginnen',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center);
    }

    DateTime date = widget.date;
    CollectionReference<ReservationObject> reservationObjectsRef =
        FirebaseFirestore.instance
            .collection('reservationObjects')
            .withConverter<ReservationObject>(
              fromFirestore: (snapshot, _) =>
                  ReservationObject.fromJson(snapshot.data()!),
              toFirestore: (reservation, _) => reservation.toJson(),
            );

    return FutureWrapper(
      future: getAvailableReservationObjects(reservationObjectsRef, filters),
      success: (snapshot) => Stack(
        children: <Widget>[
          SingleChildScrollView(
            key: UniqueKey(),
            scrollDirection: Axis.horizontal,
            child: VerticalReservationScrollViewWithStickyHeader(
              boatsController: boatsController,
              date: date,
              snapshot: snapshot,
            ),
          ), // this builds the columns with the boats and the slots
          TimeScrollView(
            timesController: timesController,
          ), // this builds the time column on the left side
        ],
      ),
      error: (error) => <Widget>[
        const ErrorCardWidget(
          errorMessage: "Er is iets misgegaan met het ophalen van de data",
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
    );
  }

  Future<QuerySnapshot<ReservationObject>> getAvailableReservationObjects(
    CollectionReference<ReservationObject> reservationObjectsRef,
    List<String> filters,
  ) {
    return reservationObjectsRef
        .where('type', whereIn: filters)
        .where('available', isEqualTo: true)
        .get();
  }
}
