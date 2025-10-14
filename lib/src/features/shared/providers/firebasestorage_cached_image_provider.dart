// ignore_for_file: avoid-importing-entrypoint-exports

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';

// ignore: prefer-static-class
final firebaseStorageCachedImageProvider =
    FutureProvider.family<ImageProvider<Object>, String>(
  (ref, path) => CachedImage.get(
    firebaseStoragePath: path,
    placeholderImagePath: Images.loadingPicture,
  ),
);
