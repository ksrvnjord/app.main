// ignore_for_file: prefer-extracting-function-callbacks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';

// ignore: prefer-static-class
final formsCollection = FirebaseFirestore.instance
    .collection('testforms')
    .withConverter<FirestoreForm>(
      fromFirestore: (snapshot, _) =>
          FirestoreForm.fromJson(snapshot.data() ?? {}),
      toFirestore: (form, _) => form.toJson(),
    );

// ignore: prefer-static-class
final openFormsProvider =
    StreamProvider.autoDispose<QuerySnapshot<FirestoreForm>>((ref) {
  return ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : formsCollection
          .where('openUntil', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('openUntil', descending: false)
          .limit(3)
          .snapshots();
});

// ignore: prefer-static-class
final allFormsProvider =
    StreamProvider.autoDispose<QuerySnapshot<FirestoreForm>>((ref) {
  return ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : formsCollection.orderBy('openUntil', descending: true).snapshots();
});

// ignore: prefer-static-class
final allFormsOnCreationProvider =
    StreamProvider.autoDispose<QuerySnapshot<FirestoreForm>>((ref) {
  return ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : formsCollection.orderBy('createdTime', descending: true).snapshots();
});

// ignore: prefer-static-class
final formProvider = StreamProvider.family<DocumentSnapshot<FirestoreForm>,
    DocumentReference<FirestoreForm>>(
  (ref, docRef) => ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : docRef.snapshots(),
);
