import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';

// ignore: prefer-static-class
final firebaseAuthUserProvider = Provider<User?>((ref) {
  // ignore: avoid-ignoring-return-values
  ref.watch(authModelProvider); // Force rebuild when auth changes.

  return FirebaseAuth.instance.currentUser;
});
