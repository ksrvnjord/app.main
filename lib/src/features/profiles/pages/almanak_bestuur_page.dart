import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/data/bestuurs_volgorde.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

final peopleRef = FirebaseFirestore.instance.collection("people").withConverter(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

class AlmanakBestuurPage extends StatelessWidget {
  const AlmanakBestuurPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot<AlmanakProfile>> getBestuur() {
      return peopleRef.where("bestuurs_functie", isNull: false).get();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bestuur"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          FutureWrapper(
            future: getBestuur(),
            success: (snapshot) => buildBestuurList(snapshot),
          ),
        ],
      ),
    );
  }

  Widget buildBestuurList(QuerySnapshot<AlmanakProfile> snapshot) {
    List<QueryDocumentSnapshot<AlmanakProfile>> docs = snapshot.docs;
    // we want to sort baseed on the bestuurs_volgorde
    docs.sort((a, b) => compareBestuursFunctie(a.data(), b.data()));

    return <Widget>[
      ...docs.map(
        (doc) => AlmanakUserTile(
          firstName: doc.data().firstName!,
          lastName: doc.data().lastName!,
          subtitle: doc.data().bestuursFunctie!,
          lidnummer: doc.data().lidnummer,
        ),
      ),
    ].toColumn();
  }

  /// Compare the bestuursfuncties op basis van constitutie
  int compareBestuursFunctie(AlmanakProfile a, AlmanakProfile b) =>
      bestuurVolgorde
          .indexOf(a.bestuursFunctie!)
          .compareTo(bestuurVolgorde.indexOf(b.bestuursFunctie!));
}
