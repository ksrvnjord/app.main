import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage.dart';
import 'package:styled_widget/styled_widget.dart';

class DamageTileWidget extends StatelessWidget {
  const DamageTileWidget({
    super.key,
    required this.showDamage,
    required this.editDamage,
    required this.damageSnapshot,
  });

  final DocumentSnapshot<Damage> damageSnapshot;
  final void Function() showDamage;
  final void Function() editDamage;

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '0';
    final Damage? damage = damageSnapshot.data();

    if (damage == null) {
      return Container();
    }

    const double trailingWidgetWidth = 80;

    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: [
        damage.critical
            ? Icon(
                Icons.report,
                color: colorScheme.onErrorContainer,
              )
            : Icon(
                Icons.warning,
                color: colorScheme.onTertiaryContainer,
              ),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
      title: Text(damage.name),
      subtitle: Text(damage.type),
      trailing: SizedBox(
        width: trailingWidgetWidth,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (damage.creatorId == uid)
            IconButton(
              onPressed: editDamage,
              icon: const Icon(
                Icons.edit,
              ),
            ),
          const Icon(
            Icons.arrow_forward_ios,
          ),
        ]),
      ),
      onTap: showDamage,
    ).card(
      color: // If damage is critical show light red, else orange.
          damage.critical
              ? colorScheme.errorContainer
              : colorScheme.tertiaryContainer,
      elevation: 0,
    );
  }
}
