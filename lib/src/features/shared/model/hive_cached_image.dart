import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

// Default expiry is one hour
const defaultExpiry = 1;

// TODO: NEEDS TO BE REWRITTEN INTO AN OBJECT-ORIENTED CLASS,
// USE CASE FOR THAT WILL PROBABLY SURFACE IN A COUPLE WEEKS OR
// SO.
Future<Uint8List?> cachedHttpImage(
  String url, {
  Duration expire = const Duration(hours: defaultExpiry),
}) async {
  // If the URL is empty, we don't need to do anything
  // at all.
  if (url == '') {
    return null;
  }

  // Create the expiry DateTime
  DateTime expireDate = DateTime.now().add(expire);

  // Initialize a Hive-cache to store the images, do it lazily
  // as we don't want to load all the images right away
  LazyBox cache = await Hive.openLazyBox('imageCache');

  // Normalize the URL to a SHA224 hash to avoid
  // key length issues
  Digest key = sha512.convert(utf8.encode(url));

  // Initialize variable to store the output in
  // from the try-catch block
  Uint8List? output;

  // Check if we have an item in our cache,
  // and then check if we should use it
  var item = await cache.get(key.toString());

  // We have it, so return it.
  if (item != null &&
      item['expire'] != null &&
      DateTime.now().isBefore(item['expire'])) {
    return item['data'];
  }

  // We don't have it, so gather it, store it, and return it.
  try {
    Response response = await Dio().get<Uint8List>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    output = response.data;
    cache.put(key.toString(), {
      'expire': expireDate,
      'data': output,
    });
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

  return output;
}
