import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;
final auth = FirebaseAuth.instance;

Future<Uint8List?> getProfilePicture(String userId) async {
  final Reference userRef = storage.ref().child(userId);
  final Reference profilePictureRef = userRef.child('profile_picture.png');
  final Uint8List? data = await profilePictureRef.getData();

  return data;
}

UploadTask uploadMyProfilePicture(File file)  {
  final String userId = auth.currentUser!.uid;
  final Reference myProfilePictureRef = storage.ref("$userId/profile_picture.png");

  return myProfilePictureRef.putFile(file);
}
