import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/form_answer.dart';

final formAnswerCountProvider =
    StreamProvider.family<int, DocumentReference<FirestoreForm>>((ref, docRef) {
  return FirebaseFirestore.instance
      .collection('${docRef.path}/answers')
      .withConverter<FormAnswer>(
        fromFirestore: (snapshot, _) =>
            FormAnswer.fromJson(snapshot.data() ?? {}),
        toFirestore: (answer, _) => answer.toJson(),
      )
      .snapshots()
      .map((snapshot) => snapshot.size); // Get live count of documents
});
