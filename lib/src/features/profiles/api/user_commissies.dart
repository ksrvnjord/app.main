// ignore_for_file: prefer-static-class
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/commissie_django_entry.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/commissie_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

final peopleRef = FirebaseFirestore.instance.collection("people");

Future<void> addMyCommissie(CommissieEntry commissie) {
  return getCommissieCollectionRefWithConverter(
    peopleRef.doc(FirebaseAuth.instance.currentUser?.uid),
  ).add(commissie);
}

final myCommissiesProvider =
    StreamProvider.autoDispose<QuerySnapshot<CommissieEntry>>((ref) {
  final userId = ref.watch(firebaseAuthUserProvider).value?.uid;

  return userId == null
      ? const Stream.empty()
      : getCommissieCollectionRefWithConverter(
          peopleRef.doc(userId),
        ).snapshots();
});

final commissiesForUserProvider =
    StreamProvider.autoDispose.family<List<GroupDjangoEntry>, String>(
  (ref, identifier) async* {
    final dio = ref.watch(dioProvider);
    final res = await dio.get("/api/users/users/", queryParameters: {
      "search": identifier,
    });
    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final results = data["results"] as List;
    final user = results.first as Map<String, dynamic>;

    final djangoId = user["id"] as int;
    final res2 = await dio.get("/api/users/users/$djangoId");
    final data2 = jsonDecode(res2.toString()) as Map<String, dynamic>;

    final commissies = (data2["groups"] as List)
        .map<GroupDjangoEntry>(
          (e) => GroupDjangoEntry.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    yield commissies;
  },
);

// Convenience method to get a reference to the commissies collection using the converter.
CollectionReference<CommissieEntry> getCommissieCollectionRefWithConverter(
  DocumentReference<Map<String, dynamic>> ref,
) {
  return ref.collection('commissies').withConverter<CommissieEntry>(
        fromFirestore: (snapshot, _) =>
            CommissieEntry.fromJson(snapshot.data() ?? {}),
        toFirestore: (commissie, _) => commissie.toJson(),
      );
}
