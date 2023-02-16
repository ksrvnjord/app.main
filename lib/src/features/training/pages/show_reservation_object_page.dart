import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_text_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

import '../widgets/availability_header.dart';
import '../widgets/calendar/widgets/permissions_widget.dart';

// get reference to reservationObjects collection
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
        backgroundColor: Colors.lightBlue,
        shadowColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
      ),
      body: FutureWrapper(
        future: getReservationObject(documentId),
        success: showObjectDetails,
      ),
    );
  }

  Widget showObjectDetails(snapshot) {
    if (!snapshot.exists) {
      return const Center(child: Text('No data'));
    }
    ReservationObject obj = snapshot.data()!;

    // show the reservationObject data in a ListView
    return Column(
      children: [
        AvailabilityHeader(isAvailable: obj.available),
        Expanded(
          child: ListView(children: [
            obj.comment != null
                ? Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    elevation: 0,
                    color: Colors.amber.shade100,
                    child: ListTile(
                      leading: const Icon(Icons.comment),
                      title: Text(
                        obj.comment!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                : Container(),
            DataTextListTile(name: "Type", value: obj.type),
            obj.kind != null
                ? DataTextListTile(name: "Categorie", value: obj.kind!)
                : Container(),
            obj.permissions.isNotEmpty
                ? PermissionsWidget(
                    permissions: obj.permissions,
                  )
                : Container(),
            obj.year != null
                ? DataTextListTile(name: "Jaar", value: obj.year!.toString())
                : Container(),
            obj.brand != null
                ? DataTextListTile(name: "Merk", value: obj.brand!)
                : Container(),
          ]),
        ),
      ],
    );
  }

  Future<DocumentSnapshot<ReservationObject>> getReservationObject(
    String documentId,
  ) {
    return reservationObjectsCollectionReference.doc(documentId).get();
  }
}
