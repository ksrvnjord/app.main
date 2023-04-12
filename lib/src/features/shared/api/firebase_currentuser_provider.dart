import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentFirebaseUserProvider =
    Provider<User?>((ref) => FirebaseAuth.instance.currentUser);
