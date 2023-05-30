import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
final myPermissionsProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  IdTokenResult? token = await FirebaseAuth.instance.currentUser
      ?.getIdTokenResult(true); // Gets new firebase token.

  final List<Object?> permissions = token?.claims?['permissions'];

  return permissions.map((e) => e.toString()).toList();
});
