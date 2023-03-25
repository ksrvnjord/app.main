import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'hive_cache.dart';
import 'image_cache_item.dart';

// Default expiry is one week
const int defaultExpiry = 24 * 7;

// TODO: NEEDS TO BE REWRITTEN INTO AN OBJECT-ORIENTED CLASS,
// USE CASE FOR THAT WILL PROBABLY SURFACE IN A COUPLE WEEKS OR
// SO.

// This function is used to get an image from the cache
// If the image is not cached, it will return null
// If there is no data in the cache, it will return the imageOnCacheHitWithNoData
Future<ImageProvider<Object>?> getHiveCachedImage(
  String key, {
  required ImageProvider<Object> imageOnCacheHitWithNoData,
}) async {
  if (key == '') {
    throw Exception('Key cannot be empty');
  }

  // Check if we have an item in our cache,
  // and then check if we should use it
  ImageCacheItem? item = await getFromHiveCache(key);

  // We have it, so return it.
  if (item != null && DateTime.now().isBefore(item.expire)) {
    return item.data == null
        ? imageOnCacheHitWithNoData
        : MemoryImage(item.data!);
  }

  return null; // no cached image found
}

// This function is used to get an image from the internet and cache it
// Only use this function if you know the image is not already cached
Future<Uint8List?> getHttpImageAndCache(
  String url, {
  required String key,
}) async {
  try {
    Response response = await Dio().get<Uint8List>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    Uint8List? output = response.data;
    putInHiveCache(key, output);

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

//// This sets the cache to empty for a key
void setEmptyImageCacheForKey(String key) => putInHiveCache(key, null);

void removeImageCacheForKey(String key) =>
    Hive.box<ImageCacheItem>('imageCache').delete(hashKeytoString(key));

/// This puts an image in the cache for a key
void putInHiveCache(String key, Uint8List? data) =>
    Hive.box<ImageCacheItem>('imageCache').put(
      hashKeytoString(key),
      ImageCacheItem(
        expire: DateTime.now().add(const Duration(hours: defaultExpiry)),
        data: data,
      ),
    );

/// This gets an image from the cache for a key
Future<ImageCacheItem?> getFromHiveCache(String key) async =>
    Hive.box<ImageCacheItem>('imageCache').get(hashKeytoString(key));

// Hashes a key to a string
String hashKeytoString(String key) =>
    sha512.convert(utf8.encode(key)).toString();

/// Deletes
Future<void> deleteAllCache() async {
  await Hive.close(); // close all open boxes
  Directory appDir = await getApplicationDocumentsDirectory();
  Directory hiveDir = Directory('${appDir.path}/${HiveCache.cachePath}');
  hiveDir.delete(recursive: true);
}
