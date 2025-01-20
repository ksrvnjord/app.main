import 'package:flutter/cupertino.dart';

@immutable
class CalendarMeasurement {
  static const double slotHeight = 56;
  static const double slotWidth = 128;
  static const int amountOfSlots = 33;
  static const int minutesInSlot = 30;
  static const double topOffsetFirstSlot = 20 + 8;
  static const int startHour = 6;
  static const int endHour = 22;
  static const double stripeWidth1726 = 8;

  static double amountOfPixelsTill1726FromTop() {
    final int minutes = ((startHour * 60) - (17 * 60 + 26)).abs();
    final double amountOfSlots = minutes / minutesInSlot;

    return amountOfSlots * slotHeight + topOffsetFirstSlot;
  }

  static double amountOfPixelsTillCurrentTimeFromTop() {
    final DateTime date = DateTime.now();
    final int minutes =
        ((startHour * 60) - (date.hour * 60 + date.minute)).abs();
    final double amountOfSlots = minutes / minutesInSlot;

    return amountOfSlots * slotHeight + topOffsetFirstSlot;
  }

  static double initialPagePosition() {
    final DateTime date = DateTime.now();
    final int minutes =
        ((startHour * 60) - (date.hour * 60 + date.minute)).abs();
    final double amountOfSlots = minutes / minutesInSlot;
    final double pixelsTillNow =
        (amountOfSlots - 3) * slotHeight + topOffsetFirstSlot;

    if (pixelsTillNow > 1200) {
      // 1180 is the maximum scroll offset
      return 1200;
    } else {
      return pixelsTillNow;
    }
  }
}
