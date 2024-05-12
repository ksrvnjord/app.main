import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlikkenLijstController
    extends StateNotifier<AsyncValue<List<QueryDocumentSnapshot<Object?>>>> {
  BlikkenLijstController() : super(const AsyncValue.loading());

  DocumentSnapshot? lastDocument;

  Future<void> fetchBlikkenLijst(String type) async {
    state = const AsyncValue.loading();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('eeuwige_blikkenlijst')
          .where('type', isEqualTo: type)
          .orderBy('blikken', descending: true)
          .limit(50)
          .get();

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
      }
      state = AsyncValue.data(snapshot.docs);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
    }
  }

  Future<void> fetchMoreBlikkenLijst(String type) async {
    if (lastDocument == null) {
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('eeuwige_blikkenlijst')
          .where('type', isEqualTo: type)
          .orderBy('blikken', descending: true)
          .startAfterDocument(lastDocument!)
          .limit(30)
          .get();

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
        if (state is AsyncData<List<QueryDocumentSnapshot<Object?>>>) {
          state.whenData((currentDocs) {
            state = AsyncValue.data(currentDocs + snapshot.docs);
          });
        }
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
    }
  }
}

final blikkenLijstProvider = StateNotifierProvider<BlikkenLijstController,
        AsyncValue<List<QueryDocumentSnapshot<Object?>>>>(
    (ref) => BlikkenLijstController());
