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
  static final LazyBox<ImageCacheItem> hiveImageCache =
      Hive.lazyBox<ImageCacheItem>('imageCache');

  static const int defaultExpiry = 24 * 7; // default cache for 1 week

  static Future<ImageCacheItem?> get(String key) {
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
  }) async {
    try {
      Response response = await Dio().get<Uint8List>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      Uint8List? output = response.data;
      HiveCache.put(key: key, value: output);

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
    int? expiry,
  }) async {
    await hiveImageCache.put(
      hashKeytoString(key),
      ImageCacheItem(
        expire: DateTime.now().add(Duration(
          hours: expiry ?? defaultExpiry,
        )),
        data: value,
      ),
    );
  }

  static Future<void> putEmpty(String key, {int? expiry}) async {
    await put(key: key, value: null, expiry: expiry);
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
  }
}
