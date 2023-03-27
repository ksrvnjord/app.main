import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservationMadeNotifier extends StateNotifier<bool> {
  ReservationMadeNotifier() : super(false);

  void madeReservation() {
    state = !state;
  }
}

final reservationMadeProvider =
    StateNotifierProvider<ReservationMadeNotifier, bool>((ref) {
  return ReservationMadeNotifier();
});
