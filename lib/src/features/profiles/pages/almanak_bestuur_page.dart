import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/widgets/profile_picture_widget.dart';
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
            success: (snapshot) => <Widget>[
              ...snapshot.docs.map(
                (doc) => ListTile(
                  leading: ProfilePictureWidget(userId: doc.id),
                  title:
                      Text("${doc.data().firstName!} ${doc.data().lastName!}"),
                  subtitle: Text(doc.data().bestuursFunctie!),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.lightBlue),
                ),
              ),
            ].toColumn(),
          ),
        ],
      ),
    );
  }
}
