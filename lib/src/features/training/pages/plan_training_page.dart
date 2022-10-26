import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanTrainingPage extends StatelessWidget {
  final String reservationObjectPath;
  final String reservationObjectName;
  final int hour;
  final int minute;
  final DateTime date;

  PlanTrainingPage({Key? key, required Map<String, dynamic> queryParams})
      : reservationObjectPath = queryParams['reservationObjectPath'] as String,
        reservationObjectName = queryParams['reservationObjectName'] as String,
        hour = queryParams['hour'] as int,
        minute = queryParams['minute'] as int,
        date = DateTime.parse(queryParams['date'] as String),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigator = Routemaster.of(context);
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference reservationsRef = db.collection('reservations');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuwe Afschrijving'),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: <Widget>[
        TextFormField(
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Afschrijven',
            border: OutlineInputBorder(),
          ),
          initialValue: 'Zephyr',
        ).padding(all: 15),
        TextFormField(
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Dag',
            border: OutlineInputBorder(),
          ),
          initialValue: '2022-09-28',
        ).padding(all: 15),
        Text('Time Slider...'),
        ElevatedButton(
                onPressed: () => {
                      reservationsRef
                          .add({
                            'object': '/reservationObjects/Alexia',
                            'creatorId': '21203',
                            'startTime': '2022-09-28T10:00:00.000Z',
                            'endTime': '2022-09-28T12:00:00.000Z',
                            'createdTime': DateTime.now(),
                          })
                          .then((value) => print("Afschrijving Added"))
                          .catchError(
                              (error) => print("Failed to add user: $error")),
                      navigator.push('/training')
                    },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                child: <Widget>[
                  const Icon(LucideIcons.check).padding(bottom: 1),
                  const Text('Afschrijven', style: TextStyle(fontSize: 18))
                      .padding(vertical: 16)
                ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween))
            .padding(all: 16)
        // Text('Menu om mensen uit te nodigen...'), TODO: not essential for first release
      ].toColumn(),
    );
  }
}
