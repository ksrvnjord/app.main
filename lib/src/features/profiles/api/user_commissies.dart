import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/commissie_entry.dart';

final peopleRef = FirebaseFirestore.instance.collection("people");

Future<void> addMyCommissie(CommissieEntry commissie) {
  return getCommissieCollectionRefWithConverter(
    peopleRef.doc(FirebaseAuth.instance.currentUser!.uid),
  ).add(commissie);
}

final myCommissiesProvider =
    StreamProvider.autoDispose<QuerySnapshot<CommissieEntry>>((ref) {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  return getCommissieCollectionRefWithConverter(
    peopleRef.doc(userId),
  ).snapshots();
});

final commissiesForUserProvider =
    FutureProvider.family<QuerySnapshot<CommissieEntry>, String>(
  (ref, userId) => getCommissieCollectionRefWithConverter(
    peopleRef.doc(userId),
  ).get(),
);

// convenience method to get a reference to the commissies collection using the converter
CollectionReference<CommissieEntry> getCommissieCollectionRefWithConverter(
  DocumentReference<Map<String, dynamic>> ref,
) {
  return ref.collection('commissies').withConverter<CommissieEntry>(
        fromFirestore: (snapshot, _) =>
            CommissieEntry.fromJson(snapshot.data()!),
        toFirestore: (commissie, _) => commissie.toJson(),
      );
}
