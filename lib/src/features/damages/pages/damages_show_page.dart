import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/get_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_show_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';

class DamagesShowPage extends StatelessWidget {
  final String damageDocumentId;
  final String reservationObjectId;

  const DamagesShowPage({
    Key? key,
    required this.damageDocumentId,
    required this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Schademelding'),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
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
