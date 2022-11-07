import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> confirmDeleteReservation(
    BuildContext context, QueryDocumentSnapshot<Object?> reservation) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Annuleren'),
        content: const Text('Weet je zeker dat je de training wil annuleren?'),
        actions: [
          TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('reservations')
                    .doc(reservation.id)
                    .delete();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Ja',
                style: TextStyle(color: Colors.green),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Nee',
                style: TextStyle(color: Colors.red),
              )),
        ],
      );
    },
  );
}
