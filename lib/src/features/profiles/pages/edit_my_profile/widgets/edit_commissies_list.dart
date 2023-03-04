import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';
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
    docs.sort((a, b) => a.data().startYear.compareTo(b.data().startYear));

    const double fieldPadding = 8;

    return Column(
      children: docs.isNotEmpty
          ? docs
              .map((doc) => ListTile(
                    leading: [
                      Text(
                        "${doc.data().startYear}-${doc.data().endYear ?? "heden"}",
                      ),
                    ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                    title: Text(doc.data().name),
                    subtitle: doc.data().function != null
                        ? Text(doc.data().function!)
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => doc.reference.delete(),
                    ),
                  ))
              .toList()
          : [
              const Text('Geen commissies gevonden, voeg een commissie toe.')
                  .padding(all: fieldPadding),
            ],
    );
  }
}
