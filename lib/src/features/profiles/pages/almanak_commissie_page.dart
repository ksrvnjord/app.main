import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/almanak_user_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:styled_widget/styled_widget.dart';

final commissiesRef = FirebaseFirestore.instance
    .collectionGroup('commissies')
    .withConverter<CommissieEntry>(
      fromFirestore: (snapshot, _) => CommissieEntry.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

class AlmanakCommissiePage extends StatefulWidget {
  const AlmanakCommissiePage({
    Key? key,
    required this.commissieName,
  }) : super(key: key);

  final String commissieName;

  @override
  AlmanakCommissiePageState createState() => AlmanakCommissiePageState();
}

class AlmanakCommissiePageState extends State<AlmanakCommissiePage> {
  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot<CommissieEntry>> getCommissieLeedenFromYear(
      String commissie,
      int year,
    ) {
      return commissiesRef
          .where('name', isEqualTo: commissie)
          .where('startYear', isEqualTo: year)
          .get();
    }

    final DateTime now = DateTime.now();
    final int njordYear = now.month >= 9 // njord year starts in september
        ? now.year
        : now.year - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.commissieName),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          FutureWrapper(
            future: getCommissieLeedenFromYear(widget.commissieName, njordYear),
            success: (snapshot) => buildCommissieList(snapshot),
            error: (error) => ErrorCardWidget(errorMessage: error.toString()),
          ),
        ],
      ),
    );
  }

  Widget buildCommissieList(QuerySnapshot<CommissieEntry> snapshot) {
    List<QueryDocumentSnapshot<CommissieEntry>> docs = snapshot.docs;

    return <Widget>[
      ...docs.map(
        (doc) => AlmanakUserTile(
          firstName: doc.data().firstName,
          lastName: doc.data().lastName,
          lidnummer: doc.data().lidnummer,
          subtitle: doc.data().function ?? "",
        ),
      ),
      Container(),
    ].toColumn();
  }
}
