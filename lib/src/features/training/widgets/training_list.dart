import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservationObject.dart';

class TrainingList extends StatelessWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference<Reservation> reservationsRef =
        db.collection('reservations').withConverter<Reservation>(
              fromFirestore: (snapshot, _) =>
                  Reservation.fromJson(snapshot.data()!),
              toFirestore: (reservation, _) => reservation.toJson(),
            );
    final CollectionReference reservationObjectsRef =
        db.collection('reservationObjects');
    DateFormat dateFormat = DateFormat('MMM d, HH:mm');

    String trainingTimeFromTimestamps(reservation) {
      final DateTime startTime = reservation['startTime'].toDate();
      final DateTime endTime = reservation['endTime'].toDate();

      final String stringStart = dateFormat.format(startTime);
      final String stringEnd = DateFormat.Hm().format(endTime);

      return ('$stringStart-$stringEnd');
    }

    return FutureBuilder<QuerySnapshot<Reservation>>(
        future: reservationsRef
            .where('creatorId', isEqualTo: 21203)
            .orderBy('startTime', descending: true)
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Reservation>> snapshot) {
          if (snapshot.hasError) {
            return const Text(
                'Laden ingeplande trainingen niet mogelijk. Probeer het later opnieuw');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ));
          } else {
            return ListView.separated(
                itemCount: snapshot.data?.docs.length ?? 0,
                padding: const EdgeInsets.all(10),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot<Reservation> reservation =
                      snapshot.data!.docs[index];
                  return FutureBuilder<DocumentSnapshot>(
                      future: reservationObjectsRef
                          .doc(reservation['object'].id)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text(
                              'Laden ingeplande training niet mogelijk');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ));
                        } else {
                          Map<String, dynamic> boat =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return ListTile(
                            tileColor: Colors.white,
                            title: Text(boat['name']),
                            subtitle:
                                Text(trainingTimeFromTimestamps(reservation)),
                            leading: const Icon(Icons.fitness_center),
                          );
                        }
                      });
                });
          }
        });
  }
}
