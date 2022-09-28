import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:styled_widget/styled_widget.dart';

class TrainingList extends StatelessWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: <Widget>[
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
      const ListTile(
              tileColor: Colors.white,
              title: Text('Afschrijving'),
              subtitle: Text('Datum - Datum'),
              leading: Icon(Icons.fitness_center))
          .elevation(2)
          .padding(all: 12),
    ].toColumn());
  }
}
