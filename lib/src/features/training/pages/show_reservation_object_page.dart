import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/damages/queries/all_object_damages.dart';
import 'package:ksrvnjord_main_app/src/features/damages/widgets/damage_tile_widget.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';
import 'package:routemaster/routemaster.dart';
import 'package:styled_widget/styled_widget.dart';

import '../widgets/availability_header.dart';
import '../widgets/calendar/widgets/chip_widget.dart';

// Get reference to reservationObjects collection.
final CollectionReference<ReservationObject>
    reservationObjectsCollectionReference = FirebaseFirestore.instance
        .collection('reservationObjects')
        .withConverter<ReservationObject>(
          fromFirestore: (snapshot, _) =>
              ReservationObject.fromJson(snapshot.data()!),
          toFirestore: (reservationObject, _) => reservationObject.toJson(),
        );

class ShowReservationObjectPage extends StatelessWidget {
  final String documentId;
  final String name;

  const ShowReservationObjectPage({
    Key? key,
    required this.documentId,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        future: getReservationObject(documentId),
        success: (snapshot) => showObjectDetails(snapshot, context),
      ),
    );
  }

  Widget showObjectDetails(
    DocumentSnapshot<ReservationObject> snapshot,
    BuildContext context,
  ) {
    const double verticalPadding = 16;
    const double horizontalPadding = 16;
    const double gap = 8;
    final navigator = Routemaster.of(context);

    if (!snapshot.exists) {
      return const Center(child: Text('No data'));
    }
    ReservationObject obj = snapshot.data()!;

    // Show the reservationObject data in a ListView.
    return [
      AvailabilityHeader(isAvailable: obj.available && !obj.critical),
      Expanded(
        child: ListView(children: [
          if (obj.comment != null && obj.comment!.isNotEmpty)
            Card(
              color: Colors.amber.shade100,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: ListTile(
                leading: const Icon(Icons.comment),
                title: Text(
                  obj.comment!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          DataTextListTile(name: "Type", value: obj.type),
          if (obj.kind != null)
            DataTextListTile(name: "Categorie", value: obj.kind!),
          if (obj.permissions.isNotEmpty)
            ChipWidget(
              title: "Permissies",
              values: obj.permissions,
              colors: const {
                'Coachcatamaran': Colors.greenAccent,
                'Speciaal': Colors.redAccent,
                '1e permissie': Colors.blueAccent,
                '2e permissie': Colors.orangeAccent,
                'Top C4+': Colors.purpleAccent,
                'Specifiek': Colors.pinkAccent,
              },
            ),
          if (obj.year != null)
            DataTextListTile(name: "Jaar", value: obj.year!.toString()),
          if (obj.brand != null)
            DataTextListTile(name: "Merk", value: obj.brand!),
          if (obj.critical)
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
            future: allObjectDamages(snapshot.id),
            success: (data) => data
                .map<Widget>((e) {
                  return e.data() != null
                      ? DamageTileWidget(
                          showDamage: () => navigator.push(
                            'damage/show',
                            queryParameters: {'id': e.id},
                          ),
                          editDamage: () => navigator.push(
                            'damage/edit',
                            queryParameters: {'id': e.id},
                          ),
                          damageSnapshot: e,
                        )
                      : Container();
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

  Future<DocumentSnapshot<ReservationObject>> getReservationObject(
    String documentId,
  ) {
    return reservationObjectsCollectionReference.doc(documentId).get();
  }
}
