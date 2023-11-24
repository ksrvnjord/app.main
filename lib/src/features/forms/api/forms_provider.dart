import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';

// ignore: prefer-static-class
final CollectionReference<FirestoreForm> formsCollection =
    FirebaseFirestore.instance.collection('forms').withConverter<FirestoreForm>(
          fromFirestore: (snapshot, _) =>
              FirestoreForm.fromJson(snapshot.data() ?? {}),
          toFirestore: (form, _) => form.toJson(),
        );

// ignore: prefer-static-class
final openFormsProvider =
    StreamProvider.autoDispose<QuerySnapshot<FirestoreForm>>((ref) {
  return ref.watch(firebaseAuthUserProvider).value != null
      ? formsCollection
          .where('openUntil', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy(
            'openUntil',
            descending: false,
          ) // Show the form with closest deadline first.
          .limit(3)
          .snapshots()
      : const Stream.empty();
});

// ignore: prefer-static-class
final formProvider =
    StreamProvider.family<DocumentSnapshot<FirestoreForm>, String>(
  (ref, formId) => ref.watch(firebaseAuthUserProvider).value != null
      ? formsCollection.doc(formId).snapshots()
      : const Stream.empty(),
);
