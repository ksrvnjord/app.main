import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlikkenLijstController
    extends StateNotifier<AsyncValue<List<QueryDocumentSnapshot<Object?>>>> {
  DocumentSnapshot? lastDocument;
  // ignore: sort_constructors_first
  BlikkenLijstController() : super(const AsyncValue.loading());

  Future<void> fetchBlikkenLijst(String type) async {
    state = const AsyncValue.loading();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('eeuwige_blikkenlijst')
          // ignore: avoid-missing-interpolation
          .where('type', isEqualTo: type)
          .orderBy('blikken', descending: true)
          .limit(50)
          .get();

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.lastOrNull;
      }
      state = AsyncValue.data(snapshot.docs);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.empty);
    }
  }

  Future<void> fetchMoreBlikkenLijst(String type) async {
    if (lastDocument == null) {
      return;
    }

    try {
      Query query = FirebaseFirestore.instance
          .collection('eeuwige_blikkenlijst')
          // ignore: avoid-missing-interpolation
          .where('type', isEqualTo: type)
          .orderBy('blikken', descending: true)
          .limit(30);

      if (lastDocument != null) {
        // ignore: avoid-non-null-assertion
        query = query.startAfterDocument(lastDocument!);
      }

      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.lastOrNull;
        if (state is AsyncData<List<QueryDocumentSnapshot<Object?>>>) {
          // ignore: avoid-ignoring-return-values
          state.whenData((currentDocs) {
            state = AsyncValue.data(currentDocs + snapshot.docs);
          });
        }
      }
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.empty);
    }
  }
}

// ignore: prefer-static-class
final blikkenLijstProvider = StateNotifierProvider<BlikkenLijstController,
    AsyncValue<List<QueryDocumentSnapshot<Object?>>>>(
  (ref) => BlikkenLijstController(),
);
