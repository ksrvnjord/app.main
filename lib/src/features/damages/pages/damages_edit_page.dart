import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/api/damage_provider.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_edit_widget.dart';
import 'package:tuple/tuple.dart';

class DamagesEditPage extends ConsumerWidget {
  final String id;
  final String reservationObjectId;

  const DamagesEditPage({
    Key? key,
    required this.id,
    required this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final damage = ref.watch(damageProvider(Tuple2(reservationObjectId, id)));

    return damage.when(
      data: (data) {
        return DamageEditWidget(
          id: id,
          reservationObjectId: reservationObjectId,
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, s) => Scaffold(
        body: Center(
          child: Text(e.toString()),
        ),
      ),
    );
  }
}
