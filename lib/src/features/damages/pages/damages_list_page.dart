import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';

class DamagesListPage extends StatelessWidget {
  final String? reservationObjectId;

  const DamagesListPage({
    Key? key,
    this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Routemaster navigator = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schademeldingen'),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: Container(),
      floatingActionButton: FirebaseAuth.instance.currentUser !=
              null // only show button if user is logged in
          ? FloatingActionButton.extended(
              onPressed: () => navigator.push('create'),
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.report),
              label: const Text('Schade melden'),
            )
          : null,
    );
  }
}
