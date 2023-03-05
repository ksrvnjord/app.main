import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:routemaster/routemaster.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_select.dart';

class DamagesCreatePage extends StatelessWidget {
  final String? reservationObjectId;

  const DamagesCreatePage({
    Key? key,
    this.reservationObjectId,
  }) : super(key: key);

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
      body: Column(children: [
        DamageSelect(),
      ]),
    );
  }
}
