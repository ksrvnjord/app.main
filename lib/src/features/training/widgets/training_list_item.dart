import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation.dart';
import 'package:ksrvnjord_main_app/src/features/training/widgets/confire_delete_reservation.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingListItem extends StatelessWidget {
  final QueryDocumentSnapshot<Reservation> snapshot;

  const TrainingListItem({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigator = Routemaster.of(context);
    final reservation = snapshot.data();

    final DateFormat dateFormat = DateFormat('E d MMM HH:mm', 'nl_NL');
    String trainingTimeFromTimestamps(reservation) {
      final DateTime startTime = reservation['startTime'].toDate();
      final DateTime endTime = reservation['endTime'].toDate();

      final String stringStart = dateFormat.format(startTime);
      final String stringEnd = DateFormat.Hm().format(endTime);

      return ('$stringStart-$stringEnd');
    }

    return ListTile(
      title: Text(reservation.objectName),
      subtitle: Text(trainingTimeFromTimestamps(snapshot)),
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
            queryParameters: {
              'reservationObjectId': reservation.reservationObject.id,
            },
          ),
          icon: const Icon(
            Icons.report,
            color: Colors.orange,
          ),
        ),
        IconButton(
          onPressed: () => confirmDeleteReservation(context, snapshot),
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
}
