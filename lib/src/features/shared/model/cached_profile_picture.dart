import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';

class CachedProfilePicture {
  static const String imagePathOnNoData = Images.placeholderProfilePicture;
  static const String keyPrefix = "profile-avatar";
  static const Duration maxAge = Duration(days: 7); // 1 week

  static Future<ImageProvider<Object>> get(String lidnummer) async {
    final key = "$keyPrefix-$lidnummer";
    ImageProvider<Object>? image = await HiveCache.getHiveCachedImage(
      key,
      imageOnCacheHitWithNoData: Image.asset(imagePathOnNoData).image,
    );
    if (image != null) {
      return image;
    }

    String? url = await getProfilePictureUrl(
      lidnummer,
    );
    if (url == null) {
      HiveCache.putEmpty(key);

      return Image.asset(imagePathOnNoData).image;
    }

    Uint8List? firestoreImage = await HiveCache.getHttpImageAndCache(
      url,
      key: keyPrefix,
      maxAge: maxAge,
    );
    if (firestoreImage == null) {
      return Image.asset(imagePathOnNoData).image;
    }

    return MemoryImage(firestoreImage);
  }

  static Reference getProfilePictureRef(String userId) {
    // Get the profile picture from a user's folder, all avatars are
    // with this filename.
    return storage.ref().child('$userId/profile_picture.png');
  }

  static Future<String?> getProfilePictureUrl(String userId) async {
    try {
      return await getProfilePictureRef(userId).getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  static Future<Uint8List?> getProfilePicture(String userId) async {
    return await getProfilePictureRef(userId).getData();
  }

  // Make function to getMyProfilePicture
  static Future<Uint8List?> getMyProfilePicture() {
    return getProfilePicture(auth.currentUser!.uid);
  }

  static UploadTask uploadMyProfilePicture(File file) {
    final String uid = auth.currentUser!.uid;
    HiveCache.delete("$keyPrefix-$uid"); // invalidate cache

    return getProfilePictureRef(uid).putFile(file);
  }
}
