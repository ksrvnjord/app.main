import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/thumbnail.dart';

// ignore: prefer-static-class
final bestuurPictureProvider =
    FutureProvider.autoDispose.family<ImageProvider<Object>, int>(
  (ref, year) {
    // ignore: avoid-ignoring-return-values
    ref.watch(firebaseAuthUserProvider);

    return CachedImage.get(
      firebaseStoragePath: "almanak/bestuur/$year/picture.jpg",
      placeholderImagePath: Images.placeholderBestuur,
      maxAge: const Duration(minutes: 5),
    );
  },
);

final bestuurThumbnailProvider =
    FutureProvider.autoDispose.family<ImageProvider<Object>, int>(
  (ref, year) {
    // ignore: avoid-ignoring-return-values
    ref.watch(firebaseAuthUserProvider);

    return CachedImage.get(
      firebaseStoragePath:
          "almanak/bestuur/$year/thumbnails/picture${Thumbnail.x800}.jpg",
      placeholderImagePath: Images.placeholderBestuur,
      maxAge: const Duration(minutes: 5),
    );
  },
);
