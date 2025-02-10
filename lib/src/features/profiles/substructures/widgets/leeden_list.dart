import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:styled_widget/styled_widget.dart';

class LeedenList extends StatelessWidget {
  const LeedenList({
    super.key,
    required this.name,
    required this.almanakProfileSnapshot,
    this.compare,
  });

  final String name;
  final QuerySnapshot<FirestoreUser> almanakProfileSnapshot;

  final int Function(
    // ignore: avoid-dynamic
    QueryDocumentSnapshot<dynamic>,
    // ignore: avoid-dynamic
    QueryDocumentSnapshot<dynamic>,
  )? compare; // Comparator function for sorting the list.

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<FirestoreUser>> docs =
        almanakProfileSnapshot.docs;
    if (compare != null) {
      docs.sort(compare); // For ordering based on functions of the members.
    } else {
      docs.sort((a, b) => b.data().identifier.compareTo(
          a.data().identifier)); // Sort by identifier in descending order
    }

    const double notFoundPadding = 16;
    const double titleHPadding = 12;
    const double titleVPadding = 8;

    return <Widget>[
      Text(
        "Leeden",
        style: Theme.of(context).textTheme.titleLarge,
      )
          .alignment(Alignment.centerLeft)
          .padding(horizontal: titleHPadding, bottom: titleVPadding),
      ...docs.map(
        (doc) => toListTile(doc),
      ),
      if (docs.isEmpty)
        Text("Geen Leeden gevonden voor $name")
            .center()
            .padding(all: notFoundPadding),
    ].toColumn();
  }

  AlmanakUserTile toListTile(
    QueryDocumentSnapshot<FirestoreUser> doc,
  ) {
    final user = doc.data();

    return AlmanakUserTile(
      firstName: user.firstName,
      lastName: user.lastName,
      lidnummer: user.identifier,
    );
  }
}
