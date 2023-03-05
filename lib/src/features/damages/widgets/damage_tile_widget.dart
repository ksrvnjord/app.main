import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageTileWidget extends StatelessWidget {
  final Damage damage;
  const DamageTileWidget({Key? key, required this.damage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '0';
    final Routemaster navigator = Routemaster.of(context);

    return ListTile(
      tileColor: Colors.white,
      title: Text(damage.name),
      subtitle: Text(damage.type),
      onTap: () => print('hey'),
      leading: Icon(
        Icons.report,
        color: Colors.red[900] ?? Colors.red,
      ),
      trailing: damage.creatorId == uid
          ? IconButton(
              onPressed: () => print('hey'),
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            )
          : Container(),
    ).border(all: 1, color: Colors.red[100] ?? Colors.white);
  }
}
