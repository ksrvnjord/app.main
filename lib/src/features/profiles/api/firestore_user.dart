import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';

final CollectionReference<AlmanakProfile> people = FirebaseFirestore.instance
    .collection('people')
    .withConverter<AlmanakProfile>(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

final firestoreUserFutureProvider =
    FutureProvider.family<QueryDocumentSnapshot<AlmanakProfile>, String>(
  (ref, userId) async {
    QuerySnapshot<AlmanakProfile> profile =
        await people.where('identifier', isEqualTo: userId).limit(1).get();

    return profile.docs.first;
  },
);
