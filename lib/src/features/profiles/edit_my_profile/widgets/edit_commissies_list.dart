import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/commissie_entry.dart';
import 'package:styled_widget/styled_widget.dart';

class EditCommissiesList extends StatelessWidget {
  const EditCommissiesList({
    super.key,
    required this.snapshot,
  });

  final QuerySnapshot<CommissieEntry> snapshot;

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<CommissieEntry>> docs = snapshot.docs;
    docs.sort((a, b) => -1 * a.data().startYear.compareTo(b.data().startYear));

    const double fieldPadding = 8;

    return Column(
      children: docs.isNotEmpty
          ? docs.map(toListTile).toList()
          : [
              const Text('Geen commissies gevonden, voeg een commissie toe.')
                  .padding(all: fieldPadding),
            ],
    );
  }

  ListTile toListTile(QueryDocumentSnapshot<CommissieEntry> doc) {
    final entry = doc.data();

    return ListTile(
      leading: [
        Text(
          "${entry.startYear}-${entry.endYear}",
        ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
      title: Text(entry.name),
      subtitle: entry.function != null ? Text(entry.function as String) : null,
      trailing: IconButton(
        onPressed: () => doc.reference.delete(),
        icon: const Icon(Icons.delete),
      ),
    );
  }
}
