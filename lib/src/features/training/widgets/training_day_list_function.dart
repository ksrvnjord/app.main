import 'package:cloud_firestore/cloud_firestore.dart';

Map<DateTime, String> reservationsToReservedSlots(
  List<QueryDocumentSnapshot> reservations,
  int timeSlotSize,
) {
  Map<DateTime, String> forbiddenSlots =
      {}; // String is id to track reservation
  Duration interval = Duration(minutes: timeSlotSize);
  for (int i = 0; i < reservations.length; i++) {
    DateTime startTime = reservations[i].get('startTime').toDate();
    DateTime endTime = reservations[i].get('endTime').toDate();
    //.subtract(const Duration(seconds: 1));

    DateTime roundedStart = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
      startTime.hour,
      [0, timeSlotSize][(startTime.minute / timeSlotSize).floor()],
    );
    DateTime roundedEnd = DateTime(
      endTime.year,
      endTime.month,
      endTime.day,
      endTime.hour,
      [
        0,
        30,
        60,
      ][(endTime.minute / timeSlotSize).ceil()],
    );

    DateTime current = roundedStart;
    while (current.isBefore(roundedEnd)) {
      forbiddenSlots[current] = reservations[i].id;
      current = current.add(interval);
    }
  }

  return forbiddenSlots;
}
