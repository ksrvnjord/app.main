import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/firestore_user.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/firestore_user.dart';

// ignore: prefer-static-class
final homeUsers =
    StreamProvider.autoDispose.family<QuerySnapshot<FirestoreUser>, String>(
  (ref, houseName) => ref.watch(firebaseAuthUserProvider).value == null
      ? const Stream.empty()
      : peopleCollection.where("huis", isEqualTo: houseName).snapshots(),
);
