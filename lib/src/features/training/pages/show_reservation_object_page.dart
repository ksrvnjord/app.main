import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  const ShowReservationObjectPage({Key? key, required this.documentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(documentId),
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
            ReservationObject reservationObject = snapshot.data()!;

            // show the reservationObject data in a ListView
            return ListView(
              children: [
                ListTile(
                  title: Text('Name'),
                  subtitle: Text(reservationObject.name),
                ),
                ListTile(
                  title: Text('Type'),
                  subtitle: Text(reservationObject.type),
                ),
              ],
            );
          },
        ));
  }

  Future<DocumentSnapshot<ReservationObject>> getReservationObject(
      String documentId) async {
    return reservationObjectsCollectionReference.doc(documentId).get();
  }
}
