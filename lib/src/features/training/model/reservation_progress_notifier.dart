import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservationProgressNotifier extends StateNotifier<bool> {
  ReservationProgressNotifier() : super(false);

  get isInProgress => state;
  get isDone => !state;
  get isNotInProgress => !state;

  void inProgress() {
    state = true;
  }

  void done() {
    state = false;
  }
}

final reservationProgressProvider =
    StateNotifierProvider<ReservationProgressNotifier, bool>((ref) {
  return ReservationProgressNotifier();
});
