import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        actions: [
          IconButton(
            onPressed: () => Routemaster.of(context).push('damage/create'),
            icon: const Icon(Icons.report),
          ),
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Colors.lightBlue,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: FutureWrapper(
        future: ref.watch(reservationObjectProvider(documentId).future),
        success: (snapshot) => showObjectDetails(snapshot, context, ref),
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
    final navigator = Routemaster.of(context);

    if (!snapshot.exists) {
      return const Center(child: Text('No data'));
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
      AvailabilityHeader(isAvailable: isVisible && !isCritical),
      Expanded(
        child: ListView(children: [
          if (comment.isNotEmpty)
            Card(
              color: Colors.amber.shade100,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: ListTile(
                leading: const Icon(Icons.comment),
                title: Text(
                  comment,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          DataTextListTile(name: "Type", value: type),
          if (kind != null) DataTextListTile(name: "Categorie", value: kind),
          if (permissions.isNotEmpty)
            ChipWidget(
              title: "Permissies",
              values: permissions,
              colors: const {
                'Coachcatamaran': Colors.greenAccent,
                'Speciaal': Colors.redAccent,
                '1e permissie': Colors.blueAccent,
                '2e permissie': Colors.orangeAccent,
                'Top C4+': Colors.purpleAccent,
                'Specifiek': Colors.pinkAccent,
              },
            ),
          if (year != null)
            DataTextListTile(name: "Jaar", value: year.toString()),
          if (brand != null) DataTextListTile(name: "Merk", value: brand),
          if (isCritical)
            const Text(
              'Schades',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ).padding(
              horizontal: horizontalPadding,
              top: verticalPadding,
              bottom: gap,
            ),
          FutureWrapper(
            future: ref
                .watch(damagesForReservationObjectProvider(snapshot.id).future),
            success: (data) => data
                .map<Widget>((e) {
                  return DamageTileWidget(
                    showDamage: () => navigator.push(
                      'damage/show',
                      queryParameters: {'id': e.id},
                    ),
                    editDamage: () => navigator.push(
                      'damage/edit',
                      queryParameters: {'id': e.id},
                    ),
                    damageSnapshot: e,
                  );
                })
                .toList()
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
