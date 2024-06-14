import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlikkenLijstController
    extends FamilyStreamNotifier<List<QueryDocumentSnapshot<Object?>>, String> {
  DocumentSnapshot? _lastDocument;
  Map<String, List<QueryDocumentSnapshot<Object?>>> _cache =
      {}; // Cache initial list for fast loading.

  Stream<List<QueryDocumentSnapshot<Object?>>> initialBlikkenLijst(
    String blikType,
  ) async* {
    if (_cache.containsKey(blikType)) {
      yield _cache[blikType]!;

      return;
    }
    // State = const AsyncValue.loading();.
    final stream = FirebaseFirestore.instance
        .collection('eeuwige_blikkenlijst')
        .where('type', isEqualTo: blikType)
        .orderBy('blikken', descending: true)
        .limit(50)
        .snapshots();

    await for (final snapshot in stream) {
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.lastOrNull;
      }
      final docs = snapshot.docs;
      _cache = {..._cache, blikType: docs};

      yield docs;
    }
  }

  @override
  Stream<List<QueryDocumentSnapshot<Object?>>> build(String arg) =>
      initialBlikkenLijst(arg);

  void fetchMoreBlikkenLijst(String blikType) async {
    if (_lastDocument == null) {
      return;
    }

    try {
      Query query = FirebaseFirestore.instance
          .collection('eeuwige_blikkenlijst')
          .where('type', isEqualTo: blikType)
          .orderBy('blikken', descending: true)
          .limit(30);

      if (_lastDocument != null) {
        // ignore: avoid-non-null-assertion
        query = query.startAfterDocument(_lastDocument!);
      }

      final stream = query.snapshots();
      await for (final snapshot in stream) {
        if (snapshot.docs.isNotEmpty) {
          _lastDocument = snapshot.docs.lastOrNull;
          if (state is AsyncData<List<QueryDocumentSnapshot<Object?>>>) {
            // ignore: avoid-ignoring-return-values
            state.whenData((currentDocs) {
              state = AsyncValue.data(currentDocs + snapshot.docs);
            });
          }
        }
      }
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.empty);
    }
  }
}

// ignore: prefer-static-class
final blikkenLijstProvider = StreamNotifierProvider.family<
    BlikkenLijstController,
    List<QueryDocumentSnapshot<Object?>>,
    String>(BlikkenLijstController.new);
