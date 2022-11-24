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
        content: const Text('Weet je zeker dat je de afschrijving wil annuleren?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },

              child: const Text(
                'Ga terug',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )),
          TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('reservations')
                    .doc(reservation.id)
                    .delete();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text(
                'Annuleer',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ],
      );
    },
  );
}
