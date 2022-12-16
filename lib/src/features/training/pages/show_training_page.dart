import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                        Map<String, dynamic> user =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return ListView(children: [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(
                                user['first_name'] + ' ' + user['last_name']),
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.start),
                            title: Text(timestampToTimeOfDay(
                                reservation['startTime']!, context)),
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.stop),
                            title: Text(timestampToTimeOfDay(
                                reservation['endTime']!, context)),
                          ),
                        ]);
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
