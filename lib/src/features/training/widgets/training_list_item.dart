import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/confire_delete_reservation.dart';

class TrainingListItem extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> reservation;

  const TrainingListItem({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DateFormat dateFormat = DateFormat('MMM d, HH:mm');
    final CollectionReference reservationObjectsRef =
        db.collection('reservationObjects');
    String trainingTimeFromTimestamps(reservation) {
      final DateTime startTime = reservation['startTime'].toDate();
      final DateTime endTime = reservation['endTime'].toDate();

      final String stringStart = dateFormat.format(startTime);
      final String stringEnd = DateFormat.Hm().format(endTime);

      return ('$stringStart-$stringEnd');
    }

    return FutureBuilder<DocumentSnapshot>(
        future: reservationObjectsRef.doc(reservation['object'].id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Laden ingeplande training niet mogelijk');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            Map<String, dynamic> boat =
                snapshot.data!.data() as Map<String, dynamic>;
            return ListTile(
              tileColor: Colors.white,
              title: Text(boat['name']),
              subtitle: Text(trainingTimeFromTimestamps(reservation)),
              leading: const Icon(
                Icons.fitness_center,
                color: Colors.blueGrey,
                ),
              trailing: IconButton(
                  onPressed: () =>
                      confirmDeleteReservation(context, reservation),
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.lightBlueAccent
                    )),
            );
          }
        });
    ;
  }
}
