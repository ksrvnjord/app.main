import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/confire_delete_reservation.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingListItem extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> reservation;

  const TrainingListItem({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigator = Routemaster.of(context);

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DateFormat dateFormat = DateFormat('E d MMM HH:mm', 'nl_NL');
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
            title: Text(boat['name']),
            subtitle: Text(trainingTimeFromTimestamps(reservation)),
            leading: const [
              Icon(
                Icons.fitness_center,
                color: Colors.blueGrey,
              ),
            ].toColumn(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            trailing: <Widget>[
              IconButton(
                onPressed: () => navigator.push(
                  '/training/createdamage',
                  queryParameters: snapshot.data?.id != null
                      ? {
                          'reservationObjectId': snapshot.data!.id,
                        }
                      : {},
                ),
                icon: const Icon(
                  Icons.report,
                  color: Colors.orange,
                ),
              ),
              IconButton(
                onPressed: () => confirmDeleteReservation(context, reservation),
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
            ].toWrap(
              direction: Axis.horizontal,
            ),
          ).card(
            color: // if damage is critical show light red, else orange
                Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.lightBlue, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          );
        }
      },
    );
  }
}
