import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/api/damage_provider.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_tile_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:routemaster/routemaster.dart';

class DamagesListPage extends ConsumerWidget {
  final double paddingY = 16;
  final double paddingX = 8;
  final double gapY = 8;

  const DamagesListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Routemaster navigator = Routemaster.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Schademeldingen'),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: FutureWrapper(
        future: ref.watch(damagesProvider.future),
        success: (data) => ListView.separated(
          padding:
              EdgeInsets.symmetric(vertical: paddingY, horizontal: paddingX),
          itemBuilder: (context, index) => DamageTileWidget(
            showDamage: () => navigator.push('show', queryParameters: {
              'id': data[index].id,
              'reservationObjectId': data[index].data().parent.id,
            }),
            editDamage: () => navigator.push('edit', queryParameters: {
              'id': data[index].id,
              'reservationObjectId': data[index].data().parent.id,
            }),
            damageSnapshot: data[index],
          ),
          separatorBuilder: (context, index) => SizedBox(height: gapY),
          itemCount: data.length,
        ),
      ),
      floatingActionButton: FirebaseAuth.instance.currentUser !=
              null // Only show button if user is logged in.
          ? FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              onPressed: () => navigator.push('create'),
              icon: const Icon(Icons.add),
              label: const Text('Nieuwe schade melden'),
            )
          : null,
    );
  }
}
