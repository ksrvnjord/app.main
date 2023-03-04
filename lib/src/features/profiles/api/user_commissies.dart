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
