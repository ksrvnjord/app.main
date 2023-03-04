import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/pages/edit_my_profile/models/commissie_entry.dart';

final peopleRef = FirebaseFirestore.instance.collection("people");

Future<void> addMyCommissie(CommissieEntry commissie) {
  return peopleRef
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("commissies")
      .withConverter<CommissieEntry>(
        fromFirestore: (snapshot, _) =>
            CommissieEntry.fromJson(snapshot.data()!),
        toFirestore: (commissie, _) => commissie.toJson(),
      )
      .add(commissie);
}

T getMyCommissies<T>() {
  return getCommissiesForUser<T>(FirebaseAuth.instance.currentUser!.uid);
}

T getCommissiesForUser<T>(String userId) {
  if (T == Stream<QuerySnapshot<CommissieEntry>>) {
    return peopleRef
        .doc(userId)
        .collection("commissies")
        .withConverter<CommissieEntry>(
          fromFirestore: (snapshot, _) =>
              CommissieEntry.fromJson(snapshot.data()!),
          toFirestore: (commissie, _) => commissie.toJson(),
        )
        .snapshots() as T;
  } else if (T == Future<QuerySnapshot<CommissieEntry>>) {
    return peopleRef
        .doc(userId)
        .collection("commissies")
        .withConverter<CommissieEntry>(
          fromFirestore: (snapshot, _) =>
              CommissieEntry.fromJson(snapshot.data()!),
          toFirestore: (commissie, _) => commissie.toJson(),
        )
        .get() as T;
  }

  throw Exception("T must be either Stream or Future");
}
