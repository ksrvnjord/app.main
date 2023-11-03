// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/huis_info.dart';

// ignore: prefer-static-class
final huisInfoProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<HuisInfo>, String>((ref, name) {
  return ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : FirebaseFirestore.instance
          .collection('group_info')
          .withConverter<HuisInfo>(
            fromFirestore: (snapshot, _) =>
                HuisInfo.fromMap(snapshot.data() ?? {}),
            toFirestore: (HuisInfo huisInfo, _) => huisInfo.toMap(),
          )
          .where('name', isEqualTo: name)
          .snapshots();
});

// ignore: prefer-static-class
final huisDescriptionProvider =
    StreamProvider.autoDispose.family<String?, String>((ref, name) async* {
  if (ref.watch(firebaseAuthUserProvider).value == null) {
    yield null;

    return;
  }

  final huis = await ref.watch(huisInfoProvider(name).future);

  yield huis.docs.first.data().description;
});
