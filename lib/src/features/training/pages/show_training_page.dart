import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error.dart';

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
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: reservations.doc(id).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const ErrorCardWidget(
                    errorMessage:
                        "We konden geen verbinding maken met de database");
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return const ErrorCardWidget(
                    errorMessage: "Er is geen afschrijving gevonden");
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> reservation =
                    snapshot.data!.data() as Map<String, dynamic>;

                return FutureBuilder<DocumentSnapshot>(
                    future: users.doc(reservation['creatorId']).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const ErrorCardWidget(
                            errorMessage:
                                "We konden de afschrijver niet ophalen");
                      }
                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const ErrorCardWidget(
                            errorMessage:
                                "We konden de afschrijver niet ophalen");
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        String creatorName;
                        Map<String, dynamic> user =
                            snapshot.data!.data() as Map<String, dynamic>;
                        if (reservation['creatorName'] != null) {
                          creatorName = reservation['creatorName'];
                        } else {
                          creatorName = // added for compatibility with old reservations, this can be removed after a while
                              user['first_name'] + ' ' + user['last_name'];
                        }

                        List<Widget> children = [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(creatorName),
                          ),
                          const Divider(),
                        ];

                        if (reservation['objectName'] != null) {
                          children.add(ListTile(
                            leading: const Icon(Icons.label),
                            title: Text(reservation['objectName']),
                          ));
                          children.add(const Divider());
                        }
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                            reservation['startTime'].millisecondsSinceEpoch);
                        String formattedDate =
                            DateFormat.yMMMMEEEEd().format(date);

                        children.addAll([
                          // add ListTile with the date
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: Text(formattedDate),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: const Icon(Icons.start),
                                  title: Text(timestampToTimeOfDay(
                                      reservation['startTime']!, context)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  leading: const Icon(Icons.timer_off_outlined),
                                  title: Text(timestampToTimeOfDay(
                                      reservation['endTime']!, context)),
                                ),
                              ),
                            ],
                          ),
                        ]);

                        return ListView(children: children);
                      }

                      return const CircularProgressIndicator();
                    });
              }

              return const CircularProgressIndicator();
            }));
  }
}

String timestampToTimeOfDay(Timestamp timestamp, BuildContext context) {
  DateTime date =
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  TimeOfDay time = TimeOfDay.fromDateTime(date);

  return time.format(context);
}
