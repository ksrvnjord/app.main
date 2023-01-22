import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/data_list_tile.dart';
import 'package:ksrvnjord_main_app/src/features/shared/widgets/future_wrapper.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

// get reference to reservationObjects collection
final CollectionReference<ReservationObject>
    reservationObjectsCollectionReference = FirebaseFirestore.instance
        .collection('reservationObjects')
        .withConverter<ReservationObject>(
            fromFirestore: (snapshot, _) =>
                ReservationObject.fromJson(snapshot.data()!),
            toFirestore: (reservationObject, _) => reservationObject.toJson());

class ShowReservationObjectPage extends StatelessWidget {
  final String documentId;
  final String name;

  const ShowReservationObjectPage(
      {Key? key, required this.documentId, required this.name})
      : super(key: key);

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
          success: (snapshot) {
            if (snapshot == null || !snapshot.exists) {
              return const Center(child: Text('No data'));
            }
            ReservationObject obj = snapshot.data()!;

            // show the reservationObject data in a ListView
            return ListView(children: [
              const Card(
                margin: EdgeInsets.only(top: 0),
                color: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Text(
                  "Beschikbaar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20),
                ),
              ),
              obj.comment != null
                  ? DataListTile(
                      icon: const Icon(Icons.comment), data: obj.comment!)
                  : Container(),
              DataTextListTile(name: "Type", value: obj.type),
              obj.kind != null
                  ? DataTextListTile(name: "Categorie", value: obj.kind!)
                  : Container(),
              obj.permissions.isNotEmpty
                  ? ListTile(
                      title: const Text(
                        'Permissies',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      subtitle: Wrap(
                        children: obj.permissions
                            .map((e) => Chip(label: Text(e)))
                            .toList(),
                      ),
                    )
                  : Container(),
              obj.year != null
                  ? DataTextListTile(name: "Jaar", value: obj.year!.toString())
                  : Container(),
              obj.brand != null
                  ? DataTextListTile(name: "Merk", value: obj.brand!)
                  : Container(),
            ]);
          },
        ));
  }

  Future<DocumentSnapshot<ReservationObject>> getReservationObject(
      String documentId) async {
    return reservationObjectsCollectionReference.doc(documentId).get();
  }
}

class DataTextListTile extends StatelessWidget {
  const DataTextListTile({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(
            color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 16),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20),
      ),
    );
  }
}
