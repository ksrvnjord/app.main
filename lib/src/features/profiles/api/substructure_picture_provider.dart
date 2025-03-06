// ignore_for_file: prefer-static-class
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/thumbnail.dart';
import 'package:tuple/tuple.dart';

final commissiePictureProvider = FutureProvider.autoDispose
    .family<ImageProvider<Object>, Tuple2<String, int>>(
  (ref, commissieAndYear) {
    final commissie = commissieAndYear.item1;
    final year = commissieAndYear.item2;

    return CachedImage.get(
      firebaseStoragePath: "almanak/commissies/$commissie/$year/picture.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(minutes: 5),
    );
  },
);

final commissieThumbnailProvider = FutureProvider.autoDispose
    .family<ImageProvider<Object>, Tuple2<String, int>>(
  (ref, commissieAndYear) {
    final commissie = commissieAndYear.item1;
    final year = commissieAndYear.item2;

    return CachedImage.get(
      firebaseStoragePath:
          "almanak/commissies/$commissie/$year/thumbnails/picture${Thumbnail.x200}.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(minutes: 5),
    );
  },
);

final substructurePictureProvider =
    FutureProvider.autoDispose.family<ImageProvider<Object>, String>(
  (ref, substructure) {
    return CachedImage.get(
      firebaseStoragePath: "almanak/substructuren/$substructure/picture.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(minutes: 5),
    );
  },
);

final substructureThumbnailProvider =
    FutureProvider.autoDispose.family<ImageProvider<Object>, String>(
  (ref, substructure) {
    return CachedImage.get(
      firebaseStoragePath:
          "almanak/substructuren/$substructure/thumbnails/picture${Thumbnail.x200}.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(minutes: 5),
    );
  },
);
