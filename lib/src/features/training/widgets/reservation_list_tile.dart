import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:styled_widget/styled_widget.dart';

class ReservationListTile extends StatelessWidget {
  const ReservationListTile({
    super.key,
    required this.snapshot,
  });

  final QueryDocumentSnapshot<Reservation> snapshot;

  @override
  Widget build(BuildContext context) {
    final reservation = snapshot.data();

    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: [Icon(Icons.fitness_center, color: colorScheme.primary)]
          .toColumn(mainAxisAlignment: MainAxisAlignment.center),
      title: Text(reservation.objectName),
      subtitle: Text(
        '${DateFormat('E d MMM HH:mm', 'nl_NL').format(reservation.startTime)}-${DateFormat.Hm().format(reservation.endTime)}',
      ),
      trailing: <Widget>[
        IconButton(
          onPressed: () => context.pushNamed('Create Damage', queryParameters: {
            'reservationObjectId': reservation.reservationObject.id,
          }),
          tooltip: "Schade melden",
          icon: Icon(Icons.report, color: colorScheme.error),
        ),
        IconButton(
          onPressed: () => showDeleteReservationDialog(context, snapshot),
          tooltip: "Afschrijving verwijderen",
          icon: Icon(Icons.cancel, color: colorScheme.outline),
        ),
      ].toWrap(direction: Axis.horizontal),
    ).card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.primary,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
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
              ),
            ),
            TextButton(
              // ignore: prefer-extracting-callbacks
              onPressed: () {
                deleteReservation(snapshot.id);
                Navigator.of(context).pop();
              },
              child: Text(
                'Verwijder mijn afschrijving',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ignore: prefer-static-class
Future<void> deleteReservation(
  String reservationId,
) async {
  await FirebaseFirestore.instance
      .collection('reservations')
      .doc(reservationId)
      .delete();
}
