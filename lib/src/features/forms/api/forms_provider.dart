// ignore_for_file: prefer-extracting-function-callbacks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

// ignore: prefer-static-class
final formsCollection = FirebaseFirestore.instance
    .collection(firestoreFormCollectionName)
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
          .where('isDraft', isEqualTo: false)
          .orderBy('openUntil', descending: false)
          .snapshots();
});

final allNonDraftFormsProvider =
    StreamProvider.autoDispose<QuerySnapshot<FirestoreForm>>((ref) {
  return ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : formsCollection
          .where('isDraft', isEqualTo: false)
          .orderBy('openUntil', descending: true)
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

final creatorNamesFormsOnCreationProvider =
    StreamProvider.autoDispose<QuerySnapshot<FirestoreForm>>((ref) async* {
  final user = ref.watch(firebaseAuthUserProvider).value;
  final creatorNames = await ref.watch(creatorNamesProvider.future);

  if (user == null) {
    yield* const Stream.empty();
    return;
  }

  final safeNames = creatorNames.isEmpty ? ['___NO_MATCH___'] : creatorNames;

  yield* formsCollection
      .where('authorName', whereIn: safeNames)
      .orderBy('createdTime', descending: true)
      .snapshots();
});

final creatorNamesProvider = FutureProvider<List<String>>((ref) async {
  final user = ref.watch(currentUserNotifierProvider);
  if (user == null) return [];

  return user.canCreateFormsFor.values.toList();
});
