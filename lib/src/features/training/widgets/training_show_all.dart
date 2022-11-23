import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_day_left_view.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_day_list.dart';
import 'package:styled_widget/styled_widget.dart';

// Shows all available objects for a given day and filters
class TrainingShowAll extends StatelessWidget {
  final DateTime date;
  final List<String> filters;

  const TrainingShowAll({
    Key? key,
    required this.date,
    required this.filters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TrainingDayLeftView(),
                      SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: snapshot.data!.docs
                                  .map<Widget>((e) {
                                    return TrainingDayList(date: date, boat: e);
                                  })
                                  .toList()
                                  .toRow(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start))
                          .expanded()
                    ]));
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
