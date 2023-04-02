import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';

final peopleRef = FirebaseFirestore.instance.collection("people").withConverter(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

final substructureUsersProvider =
    FutureProvider.family<QuerySnapshot<AlmanakProfile>, String>(
  (ref, substructuurName) =>
      peopleRef.where("substructuren", arrayContains: substructuurName).get(),
);
