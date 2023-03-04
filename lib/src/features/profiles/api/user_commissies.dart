import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';

final peopleRef = FirebaseFirestore.instance.collection("people");
final DocumentReference<Map<String, dynamic>> userRef =
    peopleRef.doc(FirebaseAuth.instance.currentUser!.uid);
final CollectionReference<CommissieEntry> userCommissiesRef = userRef
    .collection("commissies")
    .withConverter<CommissieEntry>(
      fromFirestore: (snapshot, _) => CommissieEntry.fromJson(snapshot.data()!),
      toFirestore: (commissie, _) => commissie.toJson(),
    );

Future<void> addCommissie(CommissieEntry commissie) {
  return userCommissiesRef.add(commissie);
}

// make templated function to getCommissies
T getMyCommissies<T>() {
  if (T == Stream<QuerySnapshot<CommissieEntry>>) {
    return userCommissiesRef.snapshots() as T;
  } else if (T == Future<QuerySnapshot<CommissieEntry>>) {
    return userCommissiesRef.get() as T;
  }

  throw Exception("T must be either Stream or Future");
}
