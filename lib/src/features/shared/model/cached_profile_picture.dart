import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/thumbnail.dart';

@immutable
abstract final class CachedProfilePicture {
  static const String placeholderImagePath = Images.placeholderProfilePicture;
  static const Duration maxAge = Duration(days: 7); // 1 week.

  static Future<ImageProvider<Object>> get(String lidnummer) => CachedImage.get(
        placeholderImagePath: placeholderImagePath,
        firebaseStoragePath: path(lidnummer),
        maxAge: maxAge,
      );

  static Future<ImageProvider<Object>> getThumbnail(String lidnummer) =>
      CachedImage.get(
        placeholderImagePath: placeholderImagePath,
        firebaseStoragePath: thumbnailPath(lidnummer),
        maxAge: maxAge,
      );

  // Path is the path to the image in firebase storage.
  static String path(String userId) => "$userId/profile_picture.png";

  static String thumbnailPath(String userId) =>
      "$userId/thumbnails/profile_picture${Thumbnail.x200}.png";
  // 21203/thumbnails/profile_picture_200x200.png.

  static UploadTask uploadMyProfilePicture(Uint8List imageData) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    String originalPath = CachedProfilePicture.path(uid);
    HiveCache.delete(originalPath); // Invalidate cache for my profile picture.
    String thumbnailPath = CachedProfilePicture.thumbnailPath(uid);
    HiveCache.delete(thumbnailPath); // Invalidate cache for the thumbnail.

    final metadata = SettableMetadata(contentType: 'image/jpeg');

    return FirebaseStorage.instance
        .ref(originalPath)
        .putData(imageData, metadata);
  }
}
