import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference<ReservationObject> reservationObjectsRef =
    db.collection('reservationObjects').withConverter<ReservationObject>(
          fromFirestore: (snapshot, _) =>
              ReservationObject.fromJson(snapshot.data()!),
          toFirestore: (reservation, _) => reservation.toJson(),
        );

// TODO: Find an offline-first approach for this as soon as we have a fairly
// steady state on the materiaal.
Future<Map<String, List<ReservationObject>>> reservationObjectsByType() async {
  // Initialize the map for the objects by type
  Map<String, List<ReservationObject>> objects = {};

  // Gather all the ReservationObjects that are available
  final listOfObjects =
      (await reservationObjectsRef.where('available', isEqualTo: true).get())
          .docs;

  // Populate the map by type of the reservation object
  for (var e in listOfObjects) {
    ReservationObject o = e.data();
    if (objects.containsKey(o.type)) {
      objects[o.type]?.add(o);
    } else {
      objects[o.type] = [o];
    }
  }

  // Return the generated map
  return objects;
}
