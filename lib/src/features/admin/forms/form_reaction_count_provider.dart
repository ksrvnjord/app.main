import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides a (partial) count of the reactions to a form.
// It is partial because it includes also responses that have not completed all required questions.
// ignore: prefer-static-class
final formPartialReactionCountProvider = FutureProvider.family<int, String>(
  (ref, docId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('forms')
        .doc(docId)
        .collection('answers')
        .count()
        .get();

    // ignore: avoid-non-null-assertion
    return snapshot.count!;
  },
);
