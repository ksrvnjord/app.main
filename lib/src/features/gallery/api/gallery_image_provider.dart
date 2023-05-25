import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ksrvnjord_main_app/src/features/gallery/api/gallery_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final galleryImageProvider =
    FutureProvider.family<MemoryImage, String>((ref, path) async {
  final url = await ref.watch(galleryFileUrlProvider(path).future);

  // download image from URL and return the image
  final res = await Dio().get(
    url,
    options: Options(responseType: ResponseType.bytes),
  );

  return MemoryImage(res.data);
});
