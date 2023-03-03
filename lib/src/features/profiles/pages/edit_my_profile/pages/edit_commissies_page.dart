import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

final peopleRef = FirebaseFirestore.instance.collection("people");
final DocumentReference<Map<String, dynamic>> user =
    peopleRef.doc(FirebaseAuth.instance.currentUser!.uid);
final CollectionReference<CommissieEntry> userCommissiesRef = user
    .collection("commissies")
    .withConverter<CommissieEntry>(
      fromFirestore: (snapshot, _) => CommissieEntry.fromJson(snapshot.data()!),
      toFirestore: (commissie, _) => commissie.toJson(),
    );

class EditCommissiesPage extends StatefulWidget {
  const EditCommissiesPage({Key? key}) : super(key: key);

  @override
  EditCommissiesPageState createState() => EditCommissiesPageState();
}

class EditCommissiesPageState extends State<EditCommissiesPage> {
  static const double fieldPadding = 8;
  static const double titleFontSize = 20;

  Future<List<QueryDocumentSnapshot<CommissieEntry>>> getCommissies() async {
    QuerySnapshot<CommissieEntry> snapshot = await userCommissiesRef.get();

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Commissies'),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(children: [
        const Text('Mijn Commissies')
            .textColor(Colors.blueGrey)
            .fontSize(titleFontSize)
            .padding(all: fieldPadding),
        FutureWrapper(
          future: getCommissies(),
          success: (commissies) => commissies
              .map((doc) => ListTile(
                    leading: [
                      Text("${doc.data().startYear}-${doc.data().endYear}"),
                    ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                    title: Text(doc.data().name),
                    subtitle: doc.data().function != null
                        ? Text(doc.data().function!)
                        : null,
                    trailing: const Icon(Icons.delete),
                  ))
              .toList()
              .toColumn(),
        ),
      ]),
      floatingActionButton: // button with a plus icon and the text "Commissie"
          FloatingActionButton.extended(
        onPressed: () => Routemaster.of(context).push('select'),
        label: const Text('Voeg commissie toe'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
