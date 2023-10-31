import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_almanak_profile.dart';

// ignore: prefer-static-class
final substructureUsersProvider = StreamProvider.autoDispose
    .family<QuerySnapshot<FirestoreAlmanakProfile>, String>(
  (ref, substructuurName) => ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : peopleCollection
          .where("substructures", arrayContains: substructuurName)
          .snapshots(),
);
