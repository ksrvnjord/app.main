import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/data/commissies.dart';
import 'package:styled_widget/styled_widget.dart';

final peopleRef = FirebaseFirestore.instance.collection("people").withConverter(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

class AlmanakCommissiesPage extends StatelessWidget {
  const AlmanakCommissiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commissies"),
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: ListView(
        children: commissieEmailMap.keys
            .map(
              (e) => [
                ListTile(
                  title: Text(e),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.lightBlue,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 1,
                ),
              ].toColumn(),
            )
            .toList(),
      ),
    );
  }
}
