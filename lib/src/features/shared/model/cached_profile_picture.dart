import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';

class CachedProfilePicture {
  static const String placeholderImagePath = Images.placeholderProfilePicture;
  static const Duration maxAge = Duration(days: 7); // 1 week

  static Future<ImageProvider<Object>> get(String lidnummer) => CachedImage.get(
        placeholderImagePath: placeholderImagePath,
        firebaseStoragePath: path(lidnummer),
        maxAge: maxAge,
      );

  // path is the path to the image in firebase storage
  static String path(String userId) => "$userId/profile_picture.png";

  static Future<ImageProvider<Object>> getMyProfilePicture() =>
      get(FirebaseAuth.instance.currentUser!.uid);

  static UploadTask uploadMyProfilePicture(File file) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    String myPath = path(uid);
    HiveCache.delete(myPath); // invalidate cache for my profile picture

    return FirebaseStorage.instance.ref(myPath).putFile(file);
  }
}
