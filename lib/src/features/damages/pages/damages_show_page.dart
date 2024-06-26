import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/get_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_show_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';

class DamagesShowPage extends StatelessWidget {
  const DamagesShowPage({
    super.key,
    required this.damageDocumentId,
    required this.reservationObjectId,
  });

  final String damageDocumentId;
  final String reservationObjectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schademelding'),
      ),
      body: FutureWrapper(
        future: getDamage(
          reservationObjectId,
          damageDocumentId,
        ),
        success: (data) => DamageShowWidget(
          damage: data.data(),
        ),
      ),
    );
  }
}
