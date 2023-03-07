import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageTileWidget extends StatelessWidget {
  final DocumentSnapshot<Damage> damageSnapshot;
  final void Function() showDamage;
  final void Function() editDamage;

  const DamageTileWidget({
    Key? key,
    required this.showDamage,
    required this.editDamage,
    required this.damageSnapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '0';
    final Damage? damage = damageSnapshot.data();

    if (damage == null) {
      return Container();
    }

    const double trailingWidgetWidth = 80;

    return ListTile(
      title: Text(damage.name),
      subtitle: Text(damage.type),
      onTap: showDamage,
      leading: // report icon if critical else warning icon
          [
        damage.critical
            ? Icon(
                Icons.report,
                color: Colors.red[900] ?? Colors.red,
              )
            : Icon(
                Icons.warning,
                color: Colors.orange[900] ?? Colors.orange,
              ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
      trailing: SizedBox(
        width: trailingWidgetWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (damage.creatorId == uid)
              IconButton(
                onPressed: editDamage,
                icon: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
              ),

            // show arrow forward icon to navigate to damage details
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    ).card(
      color: // if damage is critical show light red, else orange
          damage.critical ? Colors.red[100] : Colors.orange[100],
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}
