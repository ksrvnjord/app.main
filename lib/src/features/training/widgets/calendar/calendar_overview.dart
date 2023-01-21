import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/calendar_time.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/calendar/object_calendar.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:styled_widget/styled_widget.dart';

// Shows all available objects for a given day and filters
class CalendarOverview extends StatefulWidget {
  final DateTime date;
  final List<String> filters;

  const CalendarOverview({
    Key? key,
    required this.date,
    required this.filters,
  }) : super(key: key);

  @override
  createState() => _CalendarOverview();
}

class _CalendarOverview extends State<CalendarOverview> {
  late final ScrollController boatsController;
  late final ScrollController timesController;

  @override
  void initState() {
    boatsController = ScrollController();
    timesController = ScrollController();

    boatsController.addListener(() {
      if (boatsController.offset != timesController.offset) {
        timesController.jumpTo(boatsController.offset);
      }
    });

    timesController.addListener(() {
      if (timesController.offset != boatsController.offset) {
        boatsController.jumpTo(timesController.offset);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> filters = widget.filters;
    DateTime date = widget.date;

    //GraphQLClient client = Provider.of<GraphQLModel>(context).client;
    CollectionReference<ReservationObject> reservationObjectsRef =
        FirebaseFirestore.instance
            .collection('reservationObjects')
            .withConverter<ReservationObject>(
              fromFirestore: (snapshot, _) =>
                  ReservationObject.fromJson(snapshot.data()!),
              toFirestore: (reservation, _) => reservation.toJson(),
            );
    if (filters.isNotEmpty) {
      return FutureBuilder(
          future: reservationObjectsRef
              .where('type', whereIn: filters)
              .where('available', isEqualTo: true)
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<ReservationObject>> snapshot) {
            if (snapshot.hasError) {
              return const Text('Laden ingeplande training niet mogelijk');
            } else if (snapshot.data == null || snapshot.data?.docs == null) {
              return <Widget>[
                const Icon(Icons.waves, color: Colors.blueGrey).padding(all: 8),
                const Text('Geen materiaal gevonden, breid filter uit',
                    style: TextStyle(color: Colors.blueGrey))
              ].toColumn(mainAxisAlignment: MainAxisAlignment.center);
            }

            return Stack(
              children: <Widget>[
                _buildHorizontalScrollView(snapshot, date),
                _buildStickyTimeScrollView(context),
                Container(
                  // This is the top left corner, where the time and object name meet
                  color: Colors.grey[50],
                  width: 64,
                  height: 64,
                ),
              ],
            );
          });
    } else {
      return <Widget>[
        const Icon(Icons.waves, color: Colors.blueGrey).padding(all: 8),
        const Text('Geen materiaal gevonden, breid filter uit',
            style: TextStyle(color: Colors.blueGrey))
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center);
    }
  }

  SingleChildScrollView _buildHorizontalScrollView(
      AsyncSnapshot<QuerySnapshot<ReservationObject>> snapshot, DateTime date) {
    return SingleChildScrollView(
        key: UniqueKey(),
        scrollDirection: Axis.horizontal,
        child: _buildVerticalScrollViewWithStickyHeader(snapshot, date));
  }

  /// Builds the time column on the left side of the calendar
  SingleChildScrollView _buildStickyTimeScrollView(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: timesController,
        child: Container(
            color: Colors.grey[50], child: CalendarTime().padding(top: 64)));
  }

  Widget _buildVerticalScrollViewWithStickyHeader(
      AsyncSnapshot snapshot, DateTime date) {
    return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: boatsController,
            child: StickyHeader(
                header: _buildReservationObjectName(snapshot)
                    .toRow()
                    .padding(left: 64),
                content: _buildObjectCalendar(snapshot, date)
                    .toRow(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start)
                    .padding(left: 64)))
        .constrained(minWidth: MediaQuery.of(context).size.width);
  }

  List<Widget> _buildReservationObjectName(AsyncSnapshot snapshot) {
    return snapshot.data!.docs.map<Widget>(showReservationObjectName).toList();
  }

  List<Widget> _buildObjectCalendar(AsyncSnapshot snapshot, DateTime date) {
    return (snapshot.data != null
            ? snapshot.data!.docs.map<Widget>((e) {
                return ObjectCalendar(date: date, boat: e).border(
                    left: 1, color: const Color.fromARGB(255, 223, 223, 223));
              })
            : [Container()])
        .toList();
  }

  Widget showReservationObjectName(e) {
    return Container(
        color: Colors.grey[50],
        width: 96,
        height: 64,
        child: Text(e.data().name)
            .textStyle(const TextStyle(fontWeight: FontWeight.bold))
            .center());
  }
}
