import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/get_damage.dart';

class DamagesShowPage extends StatelessWidget {
  final String id;
  final String reservationObjectId;

  const DamagesShowPage({
    Key? key,
    required this.id,
    required this.reservationObjectId,
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
      body: FutureWrapper(
        future: getDamage(
          reservationObjectId,
          id,
        ),
        success: (data) => Container(),
      ),
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
