import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';

import '../../shared/model/image_cache_item.dart';

final storage = FirebaseStorage.instance;
final auth = FirebaseAuth.instance;

// gets profile picture for a user, by looking first in cache
final profilePictureProvider =
    FutureProvider.family<ImageProvider<Object>?, String>(
  (ref, identifier) async {
    // Check Hive for the Cached Image
    String cachingKey = 'profile-avatar-$identifier';
    ImageCacheItem? cacheItem = await HiveCache.get(cachingKey);
    if (cacheItem != null && DateTime.now().isBefore(cacheItem.expire)) {
      return cacheItem.data != null
          ? MemoryImage(cacheItem.data!)
          : null; // return the cached image
    }

    // Check Firebase Storage for the image
    String? url = await getProfilePictureUrl(
      identifier,
    ); // get the url from Firebase Storage
    if (url == null) {
      // no profile picture for this user
      HiveCache.putEmpty(cachingKey);

      SubstructureImage().get("hi");

      return null;
    }
    // Get the profile picture from Firebase Storage
    Uint8List? firestoreImage =
        await HiveCache.getHttpImageAndCache(url, key: cachingKey);
    if (firestoreImage == null) {
      // no profile picture for this user
      return null;
    }

    return MemoryImage(firestoreImage);
  },
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
