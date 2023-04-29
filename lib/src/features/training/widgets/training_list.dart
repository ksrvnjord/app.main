import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/stream_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/my_reservations_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/training_list_item.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingList extends ConsumerWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (FirebaseAuth.instance.currentUser == null) {
      // this should show to the user that there are no reservations
      return const Center(
        child: Text('Je hebt geen afschrijvingen'),
      );
    }

    return StreamWrapper(
      stream: ref.watch(myReservationsProvider.stream),
      success: showMyReservations,
    );
  }

  Widget showMyReservations(QuerySnapshot<Reservation> snapshot) {
    if (snapshot.docs.isEmpty) {
      return Center(
        // ignore: avoid-non-ascii-symbols
        child: const Text('Het is wel leeg hier...').textColor(Colors.blueGrey),
      );
    }

    return ListView.separated(
      itemCount: snapshot.docs.length,
      padding: const EdgeInsets.all(10),
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 4),
      itemBuilder: (BuildContext context, int index) => Center(
        child: TrainingListItem(reservation: snapshot.docs[index]),
      ),
    );
  }
}
