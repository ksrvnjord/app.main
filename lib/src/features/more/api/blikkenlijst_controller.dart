import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlikkenLijstState {

  BlikkenLijstState({
    this.documents = const [],
    this.lastDocument,
    this.totalCount,
    this.currentPage = 0,
    this.isLoading = false,
  });
  final List<QueryDocumentSnapshot<Object?>> documents;
  final DocumentSnapshot? lastDocument;
  final int? totalCount;
  final int currentPage;
  final bool isLoading;

  BlikkenLijstState copyWith({
    List<QueryDocumentSnapshot<Object?>>? documents,
    DocumentSnapshot? lastDocument,
    int? totalCount,
    int? currentPage,
    bool? isLoading,
  }) {
    return BlikkenLijstState(
      documents: documents ?? this.documents,
      lastDocument: lastDocument ?? this.lastDocument,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BlikkenLijstController extends StateNotifier<BlikkenLijstState> {
  BlikkenLijstController() : super(BlikkenLijstState());

  static const int _pageSize = 30;

  Future<void> fetchPage(String blikType, int pageKey) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);

    try {
      // Fetch total count only once
      if (state.totalCount == null) {
        final countSnapshot = await FirebaseFirestore.instance
            .collection('eeuwige_blikkenlijst')
            .where('type', isEqualTo: blikType)
            .count()
            .get();
        state = state.copyWith(totalCount: countSnapshot.count);
      }

      // Fetch paginated data
      Query query = FirebaseFirestore.instance
          .collection('eeuwige_blikkenlijst')
          .where('type', isEqualTo: blikType)
          .orderBy('blikken', descending: true)
          .limit(_pageSize);

      if (state.lastDocument != null && pageKey > 0) {
        query = query.startAfterDocument(state.lastDocument!);
      }

      final snapshot = await query.get();
      final newDocs = snapshot.docs;

      state = state.copyWith(
        lastDocument: newDocs.isNotEmpty ? newDocs.last : state.lastDocument,
        currentPage: pageKey,
        documents: [...state.documents, ...newDocs],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Failed to fetch page: $e');
    }
  }
}


final blikkenLijstProvider = StateNotifierProvider.family<BlikkenLijstController, BlikkenLijstState, String>(
  (ref, blikType) => BlikkenLijstController()..fetchPage(blikType, 0),
);