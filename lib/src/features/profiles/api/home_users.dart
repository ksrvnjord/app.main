import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/almanak_profile.dart';

final peopleRef = FirebaseFirestore.instance.collection("people").withConverter(
      fromFirestore: (snapshot, _) => AlmanakProfile.fromJson(snapshot.data()!),
      toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
    );

final homeUsers = FutureProvider.family<QuerySnapshot<AlmanakProfile>, String>(
  (ref, houseName) => peopleRef.where("huis", isEqualTo: houseName).get(),
);
