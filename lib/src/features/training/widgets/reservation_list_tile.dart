import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class ReservationListTile extends StatelessWidget {
  final QueryDocumentSnapshot<Reservation> snapshot;

  const ReservationListTile({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reservation = snapshot.data();

    return ListTile(
      leading: const [Icon(Icons.fitness_center, color: Colors.blueGrey)]
          .toColumn(mainAxisAlignment: MainAxisAlignment.center),
      title: Text(reservation.objectName),
      subtitle: Text(
        '${DateFormat('E d MMM HH:mm', 'nl_NL').format(reservation.startTime)}-${DateFormat.Hm().format(reservation.endTime)}',
      ),
      trailing: <Widget>[
        IconButton(
          onPressed: () => Routemaster.of(context)
              .push('/training/damages/create', queryParameters: {
            'reservationObjectId': reservation.reservationObject.id,
          }),
          icon: const Icon(Icons.report, color: Colors.orange),
        ),
        IconButton(
          onPressed: () => showDeleteReservationDialog(context, snapshot),
          icon: const Icon(Icons.cancel, color: Colors.red),
        ),
      ].toWrap(direction: Axis.horizontal),
    ).card(
      color: // If damage is critical show light red, else orange.
          Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.lightBlue, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }

  Future<void> showDeleteReservationDialog(
    BuildContext context,
    QueryDocumentSnapshot<Reservation> snapshot,
  ) async {
    final reservation = snapshot.data();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Afschrijving verwijderen'),
          content: Text(
            'Weet je zeker dat je jouw afschrijving voor "${reservation.objectName}" wilt verwijderen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Nee',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () => deleteReservation(snapshot, context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text(
                'Verwijder mijn afschrijving',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteReservation(
    QueryDocumentSnapshot<Reservation> snapshot,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(snapshot.id)
        .delete();

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}
