import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/commissie_entry.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final commissieLeedenProvider = FutureProvider.autoDispose
    .family<QuerySnapshot<CommissieEntry>, Tuple2<String, int>>(
  (ref, commissieAndYear) {
    final commissie = commissieAndYear.item1;
    final year = commissieAndYear.item2;

    return FirebaseFirestore.instance
        .collectionGroup('commissies')
        .withConverter<CommissieEntry>(
          fromFirestore: (snapshot, _) =>
              CommissieEntry.fromJson(snapshot.data() ?? {}),
          toFirestore: (almanakProfile, _) => almanakProfile.toJson(),
        )
        .where('name', isEqualTo: commissie)
        .where('startYear', isEqualTo: year)
        .get();
  },
);
