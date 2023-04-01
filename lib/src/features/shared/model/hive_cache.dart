import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/image_cache_item.dart';
import 'package:path_provider/path_provider.dart';

class HiveCache {
  static const String cachePath =
      'hive_cache'; // relative to ApplicationDocumentsDirectory

  static const String imageCacheBoxName = 'imageCache';
  static final LazyBox<ImageCacheItem> hiveImageCache =
      Hive.lazyBox<ImageCacheItem>(imageCacheBoxName);

  static const int defaultExpiry = 24 * 7; // default cache for 1 week

  static Future<ImageCacheItem?> get(String key) async {
    if (!hiveImageCache.isOpen) {
      await Hive.openLazyBox(imageCacheBoxName);
    }

    return hiveImageCache.get(hashKeytoString(key));
  }

  static Future<ImageProvider<Object>?> getHiveCachedImage(
    String key, {
    required ImageProvider<Object> imageOnCacheHitWithNoData,
  }) async {
    if (key == '') {
      throw Exception('Key cannot be empty');
    }
    // Check if we have an item in our cache,
    // and then check if we should use it
    ImageCacheItem? item = await HiveCache.get(key);

    // We have it, so return it.
    if (item != null && DateTime.now().isBefore(item.expire)) {
      return item.data == null
          ? imageOnCacheHitWithNoData
          : MemoryImage(item.data!);
    }

    return null; // no cached image found
  }

  static Future<Uint8List?> getHttpImageAndCache(
    String url, {
    required String key,
    Duration? maxAge,
  }) async {
    try {
      Response response = await Dio().get<Uint8List>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      Uint8List? output = response.data;
      HiveCache.put(key: key, value: output, maxAge: maxAge);

      return output;
    } on DioError catch (e) {
      // Something awful happened, check if it's 404 and if so, just
      // return null.
      const notFoundStatusCode = 404;
      if (e.response?.statusCode == notFoundStatusCode) {
        return null;
      }

      // The error is different than 404, raise!
      rethrow;
    }
  }

  static Future<void> put({
    required String key,
    Uint8List? value,
    Duration? maxAge,
  }) async {
    if (!hiveImageCache.isOpen) {
      await Hive.openLazyBox(imageCacheBoxName);
    }

    await hiveImageCache.put(
      hashKeytoString(key),
      ImageCacheItem(
        expire: DateTime.now().add(
          maxAge ?? const Duration(hours: defaultExpiry),
        ),
        data: value,
      ),
    );
  }

  static Future<void> putEmpty(String key, {Duration? expiry}) async {
    await put(key: key, value: null, maxAge: expiry);
  }

  static Future<void> delete(String key) async {
    await hiveImageCache.delete(hashKeytoString(key));
  }

  static String hashKeytoString(String key) =>
      sha512.convert(utf8.encode(key)).toString();

  static Future<void> deleteAll() async {
    await Hive.close(); // close all open lazyBoxes
    Directory appDir = await getApplicationDocumentsDirectory();
    Directory hiveDir = Directory('${appDir.path}/$cachePath');
    await hiveDir.delete(recursive: true);
    await Hive.initFlutter(
      HiveCache.cachePath,
    ); // store the cache in a separate folder
    await Hive.openLazyBox(imageCacheBoxName);
  }
}
