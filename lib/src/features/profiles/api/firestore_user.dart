import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';

final CollectionReference<FirestoreAlmanakProfile> people = FirebaseFirestore
    .instance
    .collection('people')
    .withConverter<FirestoreAlmanakProfile>(
      fromFirestore: (snapshot, _) =>
          FirestoreAlmanakProfile.fromFirestore(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
    );

final firestoreUserFutureProvider = FutureProvider.family<
    QueryDocumentSnapshot<FirestoreAlmanakProfile>, String>(
  (ref, userId) async {
    QuerySnapshot<FirestoreAlmanakProfile> profile =
        await people.where('identifier', isEqualTo: userId).limit(1).get();

    return profile.docs.first;
  },
);
