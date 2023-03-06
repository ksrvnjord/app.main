import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageTileWidget extends StatelessWidget {
  final DocumentSnapshot<Damage> damageSnapshot;
  final void Function()? showDamage;
  final void Function()? editDamage;

  const DamageTileWidget({
    Key? key,
    this.showDamage,
    this.editDamage,
    required this.damageSnapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '0';
    final Damage? damage = damageSnapshot.data();

    if (damage == null) {
      return Container();
    }

    return ListTile(
      tileColor: Colors.white,
      title: Text(damage.name),
      subtitle: Text(damage.type),
      onTap: showDamage,
      leading: Icon(
        Icons.report,
        color: Colors.red[900] ?? Colors.red,
      ),
      trailing: damage.creatorId == uid
          ? IconButton(
              onPressed: editDamage,
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            )
          : const SizedBox.shrink(),
    ).border(all: 1, color: Colors.red[100] ?? Colors.white);
  }
}
