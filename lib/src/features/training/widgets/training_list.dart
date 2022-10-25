import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingList extends StatelessWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference reservations =
        FirebaseFirestore.instance.collection('reservations');
    DateFormat dateFormat = DateFormat('MMM d, hh:mm');

    String trainingTimeFromTimestamps(reservation) {
      final DateTime startTime = reservation?.get('startTime').toDate();
      final DateTime endTime = reservation?.get('endTime').toDate();

      final String stringStart = dateFormat.format(startTime);
      final String stringEnd = DateFormat.Hm().format(endTime);

      return ('$stringStart-$stringEnd');
    }

    return FutureBuilder<QuerySnapshot>(
        future: reservations
            .where('creatorId', isEqualTo: 21203)
            .orderBy('startTime', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text(
                'Laden ingeplande trainingen niet mogelijk. Probeer het later opnieuw');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return snapshot.data?.docs != null
                ? ListView.separated(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    padding: const EdgeInsets.all(10),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot<Object?>? reservation =
                          snapshot.data?.docs[index];
                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(reservation?.get('object_name')),
                        subtitle: Text(trainingTimeFromTimestamps(reservation)),
                        leading: const Icon(Icons.fitness_center),
                      );
                    })
                : Container();
          }
        });
  }
}
