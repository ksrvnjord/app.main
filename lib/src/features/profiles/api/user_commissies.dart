import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';

final peopleRef = FirebaseFirestore.instance.collection("people");

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

Future<void> addMyCommissie(CommissieEntry commissie) {
  return getCommissieCollectionRefWithConverter(
    peopleRef.doc(FirebaseAuth.instance.currentUser!.uid),
  ).add(commissie);
}

T getMyCommissies<T>() {
  return getCommissiesForUser<T>(FirebaseAuth.instance.currentUser!.uid);
}

T getCommissiesForUser<T>(String userId) {
  if (T == Stream<QuerySnapshot<CommissieEntry>>) {
    return getCommissieCollectionRefWithConverter(
      peopleRef.doc(userId),
    ).snapshots() as T;
  } else if (T == Future<QuerySnapshot<CommissieEntry>>) {
    return getCommissieCollectionRefWithConverter(
      peopleRef.doc(userId),
    ).get() as T;
  }

  throw Exception("T must be either Stream or Future");
}
