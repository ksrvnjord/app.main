import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_list_item.dart';

class TrainingList extends StatefulWidget {
  const TrainingList({super.key});

  @override
  State<TrainingList> createState() => TrainingListState();
}

class TrainingListState extends State<TrainingList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final CollectionReference<Reservation> reservationsRef =
        db.collection('reservations').withConverter<Reservation>(
              fromFirestore: (snapshot, _) =>
                  Reservation.fromJson(snapshot.data()!),
              toFirestore: (reservation, _) => reservation.toJson(),
            );

    return StreamBuilder(
        stream: reservationsRef
            .where('creatorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('startTime',
                isGreaterThanOrEqualTo:
                    DateTime.now().subtract(const Duration(days: 1)))
            .orderBy('startTime', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              padding: const EdgeInsets.all(10),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot<Object?> reservation =
                    snapshot.data!.docs[index];
                return Center(
                    child: TrainingListItem(reservation: reservation));
              });
        });
  }
}
