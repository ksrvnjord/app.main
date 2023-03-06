import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/get_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_edit_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:provider/provider.dart';

class DamagesEditPage extends StatelessWidget {
  final String id;
  final String reservationObjectId;

  const DamagesEditPage({
    Key? key,
    required this.id,
    required this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: getDamage(
        reservationObjectId,
        id,
      ),
      success: (data) => data.exists
          ? ChangeNotifierProvider(
              create: (_) => DamageForm(
                type: data.data()!.type,
                name: data.data()!.name,
                description: data.data()!.description,
                critical: data.data()!.critical,
              ),
              child: DamageEditWidget(
                id: id,
                reservationObjectId: reservationObjectId,
              ),
            )
          : Container(),
    );
  }
}
