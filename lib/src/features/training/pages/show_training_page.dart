import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/graphql_model.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error.dart';
import 'package:provider/provider.dart';

class ShowTrainingPage extends StatelessWidget {
  final String id;
  const ShowTrainingPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('people');
    CollectionReference reservations =
        FirebaseFirestore.instance.collection('reservations');
    print("document id: $id");
    return Scaffold(
        appBar: AppBar(
          title: const Text('Afschrijving'),
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlue,
          shadowColor: Colors.transparent,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: reservations.doc(id).get(),
          builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const ErrorCardWidget(
                errorMessage: "We konden geen verbinding maken met de database");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const ErrorCardWidget(
                errorMessage: "Er is geen afschrijving gevonden");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Afschrijver',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: data['creatorId'],
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            );
          }
          return const CircularProgressIndicator();
        }));
  }
}
