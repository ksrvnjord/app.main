import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_storage.dart';

// ignore: prefer-static-class
final galleryImageProvider =
    FutureProvider.family<MemoryImage, String>((ref, path) async {
  final url = await ref.watch(galleryFileUrlProvider(path).future);

  // Download image from URL and return the image.
  final res = await Dio().get(
    url,
    options: Options(responseType: ResponseType.bytes),
  );

  return MemoryImage(res.data);
});
