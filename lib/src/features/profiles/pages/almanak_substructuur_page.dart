import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

final peopleRef = FirebaseFirestore.instance.collection("people").withConverter(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

class AlmanakSubstructuurPage extends StatelessWidget {
  const AlmanakSubstructuurPage({
    Key? key,
    required this.substructuurName,
  }) : super(key: key);

  final String substructuurName;

  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot<AlmanakProfile>> getSubstructuur() {
      return peopleRef
          .where("substructuren", arrayContains: substructuurName)
          .get();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(substructuurName),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          FutureWrapper(
            future: getSubstructuur(),
            success: (snapshot) => buildSubstructuurList(snapshot),
          ),
        ],
      ),
    );
  }

  Widget buildSubstructuurList(QuerySnapshot<AlmanakProfile> snapshot) {
    List<QueryDocumentSnapshot<AlmanakProfile>> docs = snapshot.docs;

    return <Widget>[
      ...docs.map(
        (doc) => AlmanakUserTile(
          firstName: doc.data().firstName!,
          lastName: doc.data().lastName!,
          lidnummer: doc.data().lidnummer,
        ),
      ),
    ].toColumn();
  }
}
