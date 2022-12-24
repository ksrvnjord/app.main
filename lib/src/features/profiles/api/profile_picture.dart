import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;
final String userId = FirebaseAuth.instance.currentUser!.uid;
final Reference userRef = storage.ref().child(userId);
final Reference profilePictureRef = userRef.child('profile_picture.png');

Future<Uint8List?> getProfilePicture(String userId) async {
  final Reference userRef = storage.ref().child(userId);
  final Reference profilePictureRef = userRef.child('profile_picture.png');
  final Uint8List? data = await profilePictureRef.getData();

  return data;
}
