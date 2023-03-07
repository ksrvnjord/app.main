import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_create_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/queries/get_reservation_object.dart';
import 'package:provider/provider.dart';

class DamagesCreatePage extends StatelessWidget {
  final String? reservationObjectId;

  const DamagesCreatePage({
    Key? key,
    this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reservationObjectId == null) {
      return Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => DamageForm(),
          child: const DamageCreateWidget(),
        ),
      );
    }

    return Scaffold(
      body: FutureWrapper(
        future: getReservationObject(reservationObjectId!),
        success: (data) => ChangeNotifierProvider(
          create: (_) => data.exists
              ? DamageForm(
                  type: data.data()!.type,
                  name: data.data()!.name,
                )
              : DamageForm(),
          child: const DamageCreateWidget(),
        ),
      ),
    );
  }
}
