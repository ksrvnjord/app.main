import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';

final homeUsers =
    FutureProvider.family<QuerySnapshot<FirestoreAlmanakProfile>, String>(
  (ref, houseName) => FirebaseFirestore.instance
      .collection("people")
      .withConverter(
        fromFirestore: (snapshot, _) =>
            FirestoreAlmanakProfile.fromFirestore(snapshot.data() ?? {}),
        toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
      )
      .where("huis", isEqualTo: houseName)
      .get(),
);
