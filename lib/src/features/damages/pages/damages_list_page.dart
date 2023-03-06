import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/all_damages.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_tile_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class DamagesListPage extends StatelessWidget {
  final double paddingY = 16;
  final double paddingX = 8;
  final double gapY = 8;

  const DamagesListPage({
    Key? key,
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
        future: allDamages(),
        success: (data) => data
            .map<Widget>((e) {
              return DamageTileWidget(damageSnapshot: e);
            })
            .toList()
            .toWrap(
              runSpacing: gapY,
            )
            .padding(horizontal: paddingX, vertical: paddingY),
      ).scrollable(scrollDirection: Axis.vertical),
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
