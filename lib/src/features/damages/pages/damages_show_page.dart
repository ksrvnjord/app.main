import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/get_damage.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_show_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';

class DamagesShowPage extends StatelessWidget {
  final String id;
  final String reservationObjectId;

  const DamagesShowPage({
    Key? key,
    required this.id,
    required this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schademelding'),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: FutureWrapper(
        future: getDamage(
          reservationObjectId,
          id,
        ),
        success: (data) => DamageShowWidget(
          damage: data.data(),
        ),
      ),
    );
  }
}
