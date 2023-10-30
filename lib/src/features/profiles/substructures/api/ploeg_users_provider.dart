import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/edit_my_profile/models/ploeg_entry.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final ploegUsersProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<PloegEntry>, Tuple2<String, int>>(
  (ref, nameYear) {
    return ref.watch(firebaseAuthUserProvider).value == null
        ? const Stream.empty()
        : FirebaseFirestore.instance
            .collectionGroup('groups')
            .withConverter(
              fromFirestore: (snapshot, _) =>
                  PloegEntry.fromJson(snapshot.data() ?? {}),
              toFirestore: (entry, _) => entry.toJson(),
            )
            .where('name', isEqualTo: nameYear.item1)
            .where('year', isEqualTo: nameYear.item2)
            .snapshots();
  },
);
