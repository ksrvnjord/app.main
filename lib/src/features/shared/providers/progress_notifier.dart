import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressNotifier extends StateNotifier<bool> {
  get isInProgress => state;
  get isDone => !state;
  get isNotInProgress => !state;

  ProgressNotifier() : super(false);

  void inProgress() {
    state = true;
  }

  void done() {
    state = false;
  }
}

// ignore: prefer-static-class
final progressProvider = // TODO: Riverpod has a new kind of provider for this use case.
    StateNotifierProvider<ProgressNotifier, bool>((ref) {
  return ProgressNotifier();
});
