import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlikkenLijstController extends StateNotifier<AsyncValue<QuerySnapshot>> {
  BlikkenLijstController() : super(const AsyncValue.loading());

  Future<void> fetchBlikkenLijst(String type) async {
    state = const AsyncValue.loading();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('eeuwige_blikkenlijst')
          .where('type', isEqualTo: type)
          .get();
      state = AsyncValue.data(snapshot);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
    }
  }
}

final blikkenLijstProvider =
    StateNotifierProvider<BlikkenLijstController, AsyncValue<QuerySnapshot>>(
        (ref) => BlikkenLijstController());
