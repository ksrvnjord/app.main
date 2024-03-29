import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';

// ignore: prefer-static-class
final myPermissionsProvider =
    StreamProvider.autoDispose<List<String>>((ref) async* {
  if (ref.watch(firebaseAuthUserProvider).value == null) {
    return;
  }

  IdTokenResult? token = await FirebaseAuth.instance.currentUser
      ?.getIdTokenResult(true); // Gets new firebase token.

  final List<Object?> permissions = token?.claims?['permissions'];

  yield permissions.map((e) => e.toString()).toList();
});
