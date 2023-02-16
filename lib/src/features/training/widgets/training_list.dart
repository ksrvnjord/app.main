import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/stream_wrapper.dart';
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
    if (FirebaseAuth.instance.currentUser == null) {
      // this should show to the user that there are no reservations
      return const Center(
        child: Text('Je hebt geen afschrijvingen'),
      );
    }

    return StreamWrapper(
      stream: reservationsRef
          .where(
            'creatorId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .where(
            'startTime',
            isGreaterThanOrEqualTo:
                DateTime.now().subtract(const Duration(days: 1)),
          )
          .orderBy('startTime', descending: false)
          .snapshots(),
      success: showMyReservations,
    );
  }

  Widget showMyReservations(QuerySnapshot<Reservation> snapshot) {
    if (snapshot.docs.isEmpty) {
      return const Center(
        child: Text('Je hebt geen afschrijvingen...'),
      );
    }

    return ListView.separated(
      itemCount: snapshot.docs.length,
      padding: const EdgeInsets.all(10),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) => Center(
        child: TrainingListItem(reservation: snapshot.docs[index]),
      ),
    );
  }
}
