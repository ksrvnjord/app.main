import 'package:cloud_firestore/cloud_firestore.dart';

List<DateTime> reservationsToReservedSlots(
    List<QueryDocumentSnapshot> reservations, int timeSlotSize) {
  List<DateTime> forbiddenSlots = [];
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
        [0, timeSlotSize][(startTime.minute / timeSlotSize).floor()]);
    DateTime roundedEnd = DateTime(
        endTime.year,
        endTime.month,
        endTime.day,
        endTime.hour,
        [
          0,
          30,
          60,
        ][(endTime.minute / timeSlotSize).ceil()]);

    DateTime current = roundedStart;
    while (current.isBefore(roundedEnd)) {
      forbiddenSlots.add(current);
      current = current.add(interval);
    }
  }
  return forbiddenSlots;
}
