// ignore_for_file: prefer-extracting-function-callbacks

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_storage.dart';

// ignore: prefer-static-class
final galleryImageCacheProvider = Provider<Map<String, MemoryImage>>((ref) {
  return {}; // Create a map to store cached images.
});

// ignore: prefer-static-class
final galleryImageProvider =
    FutureProvider.autoDispose.family<MemoryImage, String>((ref, path) async {
  final cache = ref.read(galleryImageCacheProvider); // Access the cache.

  // If the image is already cached, return it directly.
  if (cache.containsKey(path)) {
    return cache[path]!; // Return the cached image.
  }

  // If not cached, fetch the image from the network.
  final url = await ref.watch(galleryFileUrlProvider(path).future);

  final res = await Dio().get(
    url,
    options: Options(responseType: ResponseType.bytes),
  );

  final image = MemoryImage(res.data);

  // Cache the image manually.
  cache[path] = image;

  return image;
});
