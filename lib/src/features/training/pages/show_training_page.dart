import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';

class ShowTrainingPage extends StatelessWidget {
  final String id;
  const ShowTrainingPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('people');
    CollectionReference reservations =
        FirebaseFirestore.instance.collection('reservations');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Afschrijving'),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: reservations.doc(id).get(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return const ErrorCardWidget(
              errorMessage: "We konden geen verbinding maken met de database",
            );
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const ErrorCardWidget(
              errorMessage: "Er is geen afschrijving gevonden",
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> reservation =
                snapshot.data!.data() as Map<String, dynamic>;

            return FutureBuilder<DocumentSnapshot>(
              future: users.doc(reservation['creatorId']).get(),
              builder: (
                BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot,
              ) {
                if (snapshot.hasError) {
                  return const ErrorCardWidget(
                    errorMessage: "We konden de afschrijver niet ophalen",
                  );
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const ErrorCardWidget(
                    errorMessage: "We konden de afschrijver niet ophalen",
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  String creatorName;
                  Map<String, dynamic> user =
                      snapshot.data!.data() as Map<String, dynamic>;
                  creatorName = reservation['creatorName'] ??
                      user['first_name'] + ' ' + user['last_name'];

                  List<Widget> children = [
                    DataListTile(
                      icon: const Icon(Icons.person),
                      data: creatorName,
                    ),
                    const Divider(),
                  ];

                  if (reservation['objectName'] != null) {
                    children.add(DataListTile(
                      icon: const Icon(Icons.label),
                      data: reservation['objectName'],
                    ));
                    children.add(const Divider());
                  }
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(
                    reservation['startTime'].millisecondsSinceEpoch,
                  );
                  String formattedDate =
                      DateFormat.yMMMMEEEEd('nl_NL').format(date);

                  children.addAll([
                    // add ListTile with the date
                    DataListTile(
                      icon: const Icon(Icons.calendar_today),
                      data: formattedDate,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: DataListTile(
                            icon: const Icon(Icons.start),
                            data: timestampToTimeOfDay(
                              reservation['startTime']!,
                              context,
                            ),
                          ),
                        ),
                        Expanded(
                          child: DataListTile(
                            icon: const Icon(Icons.timer_off_outlined),
                            data: timestampToTimeOfDay(
                              reservation['endTime']!,
                              context,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]);

                  return ListView(children: children);
                }

                return const CircularProgressIndicator();
              },
            );
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

String timestampToTimeOfDay(Timestamp timestamp, BuildContext context) {
  DateTime date =
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  TimeOfDay time = TimeOfDay.fromDateTime(date);

  return time.format(context);
}
