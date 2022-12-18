import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_day_left_view.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_day_list.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:styled_widget/styled_widget.dart';

// Shows all available objects for a given day and filters
class TrainingShowAll extends StatefulWidget {
  final DateTime date;
  final List<String> filters;

  const TrainingShowAll({
    Key? key,
    required this.date,
    required this.filters,
  }) : super(key: key);

  @override
  createState() => _TrainingShowAll();
}

class _TrainingShowAll extends State<TrainingShowAll> {
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
            return Stack(children: <Widget>[
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          controller: boatsController,
                          child: StickyHeader(
                              header: [
                                snapshot.data!.docs
                                    .map<Widget>((e) {
                                      return Container(
                                          color: Colors.grey[50],
                                          width: 96,
                                          height: 64,
                                          child: Text(e.data().name)
                                              .textStyle(const TextStyle(
                                                  fontWeight: FontWeight.bold))
                                              .center());
                                    })
                                    .toList()
                                    .toRow()
                                    .padding(left: 64)
                              ].toRow(),
                              content: snapshot.data!.docs
                                  .map<Widget>((e) {
                                    return TrainingDayList(date: date, boat: e);
                                  })
                                  .toList()
                                  .toRow(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start)
                                  .padding(left: 64)))
                      .constrained(
                          minWidth: MediaQuery.of(context).size.width)),
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: timesController,
                  child: Container(
                      color: Colors.grey[50],
                      child: TrainingDayLeftView().padding(top: 64))),
              Container(
                color: Colors.grey[50],
                width: 64,
                height: 64,
              )
            ]);
          });
    } else {
      return <Widget>[
        const Icon(Icons.waves, color: Colors.blueGrey).padding(all: 8),
        const Text('Geen materiaal gevonden, breid filter uit',
            style: TextStyle(color: Colors.blueGrey))
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center);
    }
  }
}
