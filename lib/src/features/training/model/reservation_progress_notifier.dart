import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservationProgressNotifier extends StateNotifier<bool> {
  get isInProgress => state;
  get isDone => !state;
  get isNotInProgress => !state;

  ReservationProgressNotifier() : super(false);

  void inProgress() {
    state = true;
  }

  void done() {
    state = false;
  }
}

// ignore: prefer-static-class
final reservationProgressProvider =
    StateNotifierProvider<ReservationProgressNotifier, bool>((ref) {
  return ReservationProgressNotifier();
});
