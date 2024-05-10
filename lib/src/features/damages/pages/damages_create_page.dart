import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/model/damage_form.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_create_widget.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/error_card_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

class DamagesCreatePage extends ConsumerWidget {
  final String? reservationObjectId;

  const DamagesCreatePage({
    super.key,
    this.reservationObjectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (reservationObjectId == null) {
      return const Scaffold(
        body: DamageCreateWidget(),
      );
    }

    final reservationObject =
        ref.watch(reservationObjectProvider(reservationObjectId ?? ""));

    return Scaffold(
      body: reservationObject.when(
        data: (data) {
          if (!data.exists) {
            return const DamageCreateWidget();
          }

          // TODO: this is not a nice solution, its like calling setState() in the build method.
          Future.delayed(
            const Duration(milliseconds: 1),
            // ignore: prefer-extracting-callbacks
            () {
              final form = ref.read(damageFormProvider.notifier);
              ReservationObject? object = data.data();
              form.type = object?.type;
              form.name = object?.name;
            },
          );

          return const DamageCreateWidget();
        },
        loading: () => null,
        error: (e, s) => Center(
          child: ErrorCardWidget(errorMessage: e.toString()),
        ),
      ),
    );
  }
}
