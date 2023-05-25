import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';

// ignore: prefer-static-class
final substructureUsersProvider = FutureProvider.autoDispose
    .family<QuerySnapshot<FirestoreAlmanakProfile>, String>(
  (ref, substructuurName) => FirebaseFirestore.instance
      .collection("people")
      .withConverter(
        fromFirestore: (snapshot, _) =>
            FirestoreAlmanakProfile.fromFirestore(snapshot.data() ?? {}),
        toFirestore: (almanakProfile, _) => almanakProfile.toFirestore(),
      )
      .where("substructuren", arrayContains: substructuurName)
      .get(),
);
