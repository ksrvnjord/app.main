import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/profile_picture.dart';
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
}
