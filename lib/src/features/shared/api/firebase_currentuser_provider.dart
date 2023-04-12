import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/auth_model.dart';

final firebaseAuthUserProvider = Provider<User?>((ref) {
  final _ = ref.watch(authModelProvider); // Force rebuild when auth changes.

  return FirebaseAuth.instance.currentUser;
});
