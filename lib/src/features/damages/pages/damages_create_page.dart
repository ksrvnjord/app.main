import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';

class DamagesCreatePage extends StatefulWidget {
  final String? reservationObjectId;

  const DamagesCreatePage({
    Key? key,
    this.reservationObjectId,
  }) : super(key: key);

  @override
  State<DamagesCreatePage> createState() => _DamagesCreatePageState();
}

class _DamagesCreatePageState extends State<DamagesCreatePage> {
  @override
  Widget build(BuildContext context) {
    Routemaster navigator = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schade melden'),
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
              onPressed: () => navigator.push('new'),
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.report),
              label: const Text('Schade melden'),
            )
          : null,
    );
  }
}
