import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;
final auth = FirebaseAuth.instance;

Reference getProfilePictureRef(String userId) {
  // Get the profile picture from a user's folder, all avatars are
  // with this filename.
  return storage.ref().child('$userId/profile_picture.png');
}

Future<Uint8List?> getProfilePicture(String userId) async {
  // Define the variable before populating it
  Uint8List? picture;

  // Get the profile picture using the reference
  try {
    picture = await getProfilePictureRef(userId).getData();
  } on FirebaseException catch (e) {
    // Check if the issue is a 404, if not, do throw.
    if (e.code != 'object-not-found') {
      rethrow;
    }
  }

  return picture;
}

Future<String?> getProfilePictureUrl(String userId) async {
  // Define the variable before populating it
  String? picture;

  // Get the profile picture using the reference
  try {
    picture = await getProfilePictureRef(userId).getDownloadURL();
  } on FirebaseException catch (e) {
    // Check if the issue is a 404, if not, do throw.
    if (e.code == 'object-not-found') {
      picture = null;
    }

    // Likely a legit issue, so rethrow to raise the exception to Sentry
    rethrow;
  }

  return picture;
}

// Make function to getMyProfilePicture
Future<Uint8List?> getMyProfilePicture() {
  return getProfilePicture(auth.currentUser!.uid);
}

UploadTask uploadMyProfilePicture(File file) {
  return getProfilePictureRef(auth.currentUser!.uid).putFile(file);
}
