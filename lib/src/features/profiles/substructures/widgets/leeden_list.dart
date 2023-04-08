import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
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
  final QuerySnapshot<AlmanakProfile> almanakProfileSnapshot;

  final int Function(
    // ignore: avoid-dynamic
    QueryDocumentSnapshot<dynamic>,
    // ignore: avoid-dynamic
    QueryDocumentSnapshot<dynamic>,
  )? compare; // comparator function for sorting the list

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot<AlmanakProfile>> docs =
        almanakProfileSnapshot.docs;
    if (compare != null) {
      docs.sort(compare); // for ordering based on functions of the members
    }

    const double notFoundPadding = 16;
    const double titleFontSize = 20;
    const double titleHPadding = 16;
    const double titleVPadding = 8;

    return <Widget>[
      const Text("Leeden")
          .textColor(Colors.blueGrey)
          .fontSize(titleFontSize)
          .fontWeight(FontWeight.w500)
          .alignment(Alignment.centerLeft)
          .padding(horizontal: titleHPadding, bottom: titleVPadding),
      ...docs.map(
        (doc) => AlmanakUserTile(
          firstName: doc.data().firstName!,
          lastName: doc.data().lastName!,
          lidnummer: doc.data().lidnummer,
        ),
      ),
      if (docs.isEmpty)
        Text("Geen Leeden gevonden voor $name")
            .textColor(Colors.grey)
            .center()
            .padding(all: notFoundPadding),
    ].toColumn();
  }
}
