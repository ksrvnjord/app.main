import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';

class CachedImage {
  /// Fetches an image from the cache or Firebase Storage
  ///
  /// If the image is not cached, it will be downloaded from Firebase Storage and
  /// cached.
  ///
  /// If the image is cached, it will be returned from the cache, unless it is
  /// older than [maxAge], in which case it will be downloaded again from Firebase
  /// Storage and cached.
  ///
  /// If the image is not cached and the URL cannot be fetched from Firebase
  /// Firestore, an empty entry will be cached so that we know that we have already
  /// attempted to fetch the image URL.
  ///
  /// If the image is not cached and the URL cannot be fetched from Firebase
  /// Firestore, [placeholderImagePath] will be used as a placeholder image.
  ///
  /// [firebaseStoragePath] is the path to the image in Firebase Storage.
  /// [placeholderImagePath] is the path to the placeholder image.
  /// [maxAge] is the maximum age of the cached image. If the cached image is
  /// older than this, it will be downloaded again from Firebase Storage and
  /// cached.
  /// Returns an [ImageProvider] that can be used to display the image.
  ///
  static Future<ImageProvider<Object>> get({
    required String firebaseStoragePath,
    required String placeholderImagePath,
    Duration maxAge = const Duration(days: 7),
  }) async {
    final placeholderImage = Image.asset(placeholderImagePath).image;
    ImageProvider<Object>? cachedImage = await HiveCache.getHiveCachedImage(
      firebaseStoragePath,
      imageOnCacheHitWithNoData: placeholderImage,
    );
    if (cachedImage != null) {
      return cachedImage;
    }
    // Image is not cached, so we need to fetch it from the network
    String? url = await getUrl(firebaseStoragePath);
    ImageProvider<Object> placeholder = placeholderImage;
    if (url == null) {
      // there is no image at this path in Firebase Storage
      HiveCache.putEmpty(firebaseStoragePath);

      return placeholder;
    }

    // We have url of image, so now we can download and cache it
    Uint8List? firestoreImage = await HiveCache.getHttpImageAndCache(
      url,
      key: firebaseStoragePath,
      maxAge: maxAge,
    );
    if (firestoreImage == null) {
      return placeholder;
    }

    return MemoryImage(firestoreImage);
  }

  /// Returns the FirebaseStorage download url of the image at the given path, or null if it doesn't exist
  static Future<String?> getUrl(String path) async {
    try {
      return await FirebaseStorage.instance.ref(path).getDownloadURL();
    } catch (e) {
      log("Error getting Url for object on $path", error: e);

      return null;
    }
  }
}
