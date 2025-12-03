import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';

final formAnswerCountProvider =
    StreamProvider.family<int, DocumentReference<FirestoreForm>>((ref, docRef) {
  return FirebaseFirestore.instance
      .collection('${firestoreFormCollectionName}_statistics')
      .doc(docRef.id) // Use docRef.id to match the stats document
      .snapshots()
      .map((snapshot) => snapshot.data()?['answerCount'] as int? ?? 0);
});
