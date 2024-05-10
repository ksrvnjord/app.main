import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlikkenLijstItem extends StatelessWidget {
  final DocumentSnapshot document;

  const BlikkenLijstItem({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(document['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aantal blikken: ${document['aantal_blikken']}'),
            Text('Aantal premies: ${document['aantal_premies']}'),
            Text('Periode: ${document['periode']}'),
          ],
        ),
      ),
    );
  }
}
