import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';

// ignore: prefer-static-class
final allCompletedAnswersProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<FormAnswer>, String>((ref, String docId) {
  return FirebaseFirestore.instance
      .collection('forms')
      .doc(docId)
      .collection('answers')
      .where(FormAnswer.isCompletedJSONKey, isEqualTo: true)
      .withConverter<FormAnswer>(
        fromFirestore: (snapshot, _) =>
            FormAnswer.fromJson(snapshot.data() ?? {}),
        toFirestore: (answer, _) => answer.toJson(),
      )
      .orderBy('answeredAt', descending: true)
      // Relevant for admin view of form answers.
      .snapshots();
});
