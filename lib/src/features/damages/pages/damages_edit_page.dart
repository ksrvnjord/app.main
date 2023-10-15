import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/damages/api/damage_provider.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_edit_widget.dart';
import 'package:tuple/tuple.dart';

class DamagesEditPage extends ConsumerWidget {
  final String damageDocumentId;
  final String reservationObjectId;

  const DamagesEditPage({
    Key? key,
    required this.damageDocumentId,
    required this.reservationObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final damage = ref
        .watch(damageProvider(Tuple2(reservationObjectId, damageDocumentId)));

    return damage.when(
      data: (data) {
        return DamageEditWidget(
          damageDocumentId: damageDocumentId,
          reservationObjectId: reservationObjectId,
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
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
