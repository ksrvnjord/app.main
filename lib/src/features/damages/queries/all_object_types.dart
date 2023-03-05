import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference<ReservationObject> reservationObjectsRef =
    db.collection('reservationObjects').withConverter<ReservationObject>(
          fromFirestore: (snapshot, _) =>
              ReservationObject.fromJson(snapshot.data()!),
          toFirestore: (reservation, _) => reservation.toJson(),
        );

Future<Map<String, List<ReservationObject>>> reservationObjectsByType() async {
  // Initialize the map for the objects by type
  Map<String, List<ReservationObject>> objects = {};

  // Gather all the ReservationObjects that are available
  final listOfObjects =
      (await reservationObjectsRef.where('available', isEqualTo: true).get())
          .docs;

  // Populate the map by type of the reservation object
  for (var e in listOfObjects) {
    if (objects.containsKey(e.data().type)) {
      objects[e.data().type]?.add(e.data());
    } else {
      objects[e.data().type] = [e.data()];
    }
  }

  // Return the generated map
  return objects;
}
