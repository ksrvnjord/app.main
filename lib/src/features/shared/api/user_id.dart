import 'package:firebase_auth/firebase_auth.dart';

String? getCurrentUserId() {
  return FirebaseAuth.instance.currentUser?.uid;
}
