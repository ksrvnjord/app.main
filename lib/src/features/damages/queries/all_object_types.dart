import 'package:ksrvnjord_main_app/src/features/training/model/reservation_object.dart';

// TODO: Find an offline-first approach for this as soon as we have a fairly
// steady state on the materiaal.
// ignore: prefer-static-class
Future<Map<String, List<ReservationObject>>> reservationObjectsByType() async {
  // Initialize the map for the objects by type.
  Map<String, List<ReservationObject>> objects = {};

  // Gather all the ReservationObjects that are available.
  final listOfObjects = (await ReservationObject.firestoreConverter
          .where('available', isEqualTo: true)
          .get())
      .docs;

  // Populate the map by type of the reservation object.
  for (final e in listOfObjects) {
    ReservationObject object = e.data();
    if (objects.containsKey(object.type)) {
      objects[object.type]?.add(object);
    } else {
      objects[object.type] = [object];
    }
  }

  // Return the generated map.
  return objects;
}
