import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_profile_picture.dart';

final storage = FirebaseStorage.instance;
final auth = FirebaseAuth.instance;

// gets profile picture for a user, by looking first in cache
final profilePictureProvider =
    FutureProvider.family<ImageProvider<Object>?, String>(
  (ref, identifier) => CachedProfilePicture.get(identifier),
);

Reference getProfilePictureRef(String userId) {
  // Get the profile picture from a user's folder, all avatars are
  // with this filename.
  return storage.ref().child('$userId/profile_picture.png');
}

Future<Uint8List?> getProfilePicture(String userId) async {
  return await getProfilePictureRef(userId).getData();
}

Future<String?> getProfilePictureUrl(String userId) async {
  try {
    return await getProfilePictureRef(userId).getDownloadURL();
  } catch (e) {
    return null;
  }
}

// Make function to getMyProfilePicture
Future<Uint8List?> getMyProfilePicture() {
  return getProfilePicture(auth.currentUser!.uid);
}

UploadTask uploadMyProfilePicture(File file) {
  return getProfilePictureRef(auth.currentUser!.uid).putFile(file);
}
