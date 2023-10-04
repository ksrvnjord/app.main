import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/damages/api/damage_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_tile_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/api/reservation_object_provider.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

import '../widgets/availability_header.dart';
import '../widgets/calendar/widgets/chip_widget.dart';

class ShowReservationObjectPage extends ConsumerWidget {
  final String documentId;
  final String name;

  const ShowReservationObjectPage({
    Key? key,
    required this.documentId,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureWrapper(
        future: ref.watch(reservationObjectProvider(documentId).future),
        success: (snapshot) => showObjectDetails(snapshot, context, ref),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('Create Damage'),
        icon: const Icon(Icons.report),
        label: Text('Meld schade voor "$name"'),
      ),
    );
  }

  Widget showObjectDetails(
    DocumentSnapshot<ReservationObject> snapshot,
    BuildContext context,
    WidgetRef ref,
  ) {
    const double verticalPadding = 16;
    const double horizontalPadding = 16;
    const double gap = 8;

    if (!snapshot.exists) {
      return const Center(
        child: Text(
          'We konden dit object niet vinden, neem contact op met de Appcommissie',
        ),
      );
    }
    final obj = snapshot.data();
    final isVisible = obj?.available ?? false;
    final isCritical = obj?.critical ?? false;
    final comment = obj?.comment ?? '';
    final type = obj?.type ?? '';
    final permissions = obj?.permissions ?? [];
    final year = obj?.year;
    final brand = obj?.brand;
    final kind = obj?.kind;

    // Show the reservationObject data in a ListView.
    return [
      Expanded(
        child: ListView(children: [
          AvailabilityHeader(isAvailable: isVisible && !isCritical),
          if (comment.isNotEmpty)
            Card(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: ListTile(
                leading: const Icon(Icons.comment),
                title: Text(
                  comment,
                ),
              ),
            ),
          DataTextListTile(name: "Type", value: type),
          if (kind != null) DataTextListTile(name: "Categorie", value: kind),
          if (permissions.isNotEmpty)
            ChipWidget(
              title: "Permissies",
              values: permissions,
              colors: {
                'Coachcatamaran': Colors.greenAccent.shade100,
                'Speciaal': Colors.redAccent.shade100,
                '1e permissie': Colors.blueAccent.shade100,
                '2e permissie': Colors.orangeAccent.shade100,
                'Top C4+': Colors.purpleAccent.shade100,
                'Specifiek': Colors.pinkAccent.shade100,
              },
            ),
          if (year != null)
            DataTextListTile(name: "Jaar", value: year.toString()),
          if (brand != null) DataTextListTile(name: "Merk", value: brand),
          FutureWrapper(
            future: ref.watch(
              damagesForReservationObjectProvider(snapshot.id).future,
            ),
            success: (data) => [
              if (data.isNotEmpty)
                Text(
                  'Schades',
                  style: Theme.of(context).textTheme.labelLarge,
                ).padding(top: gap),
              ...data.map<Widget>((e) {
                return DamageTileWidget(
                  showDamage: () => context.pushNamed(
                    'Show Damage',
                    queryParameters: {
                      'id': e.id,
                      'reservationObjectId': e.data().parent.id,
                    },
                  ),
                  editDamage: () => context.pushNamed(
                    'Edit Damage',
                    queryParameters: {'id': e.id},
                  ),
                  damageSnapshot: e,
                );
              }),
            ]
                .toWrap(
                  runSpacing: gap,
                )
                .padding(
                  horizontal: horizontalPadding,
                  bottom: verticalPadding,
                ),
          ),
        ]),
      ),
    ].toColumn();
  }
}
