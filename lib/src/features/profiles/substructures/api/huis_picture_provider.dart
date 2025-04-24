import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/thumbnail.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final huisPictureProvider = FutureProvider.autoDispose
    .family<ImageProvider<Object>, Tuple2<String, int>>(
  (ref, huisAndYear) async {
    final huis = huisAndYear.item1;
    final year = huisAndYear.item2;

    final currentYearPicture = await CachedImage.get(
      firebaseStoragePath: "almanak/huizen/$huis/$year/picture.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(minutes: 5),
    );

    return currentYearPicture == AssetImage(Images.placeholderProfilePicture)
        ? CachedImage.get(
            firebaseStoragePath: "almanak/huizen/$huis/${year - 1}/picture.jpg",
            placeholderImagePath: Images.placeholderProfilePicture,
            maxAge: const Duration(minutes: 5),
          )
        : currentYearPicture;
  },
);

// ignore: prefer-static-class
final huisThumbnailProvider = FutureProvider.autoDispose
    .family<ImageProvider<Object>, Tuple2<String, int>>(
  (ref, huisAndYear) async {
    final huis = huisAndYear.item1;
    final year = huisAndYear.item2;

    final currentYearThumbnail = await CachedImage.get(
      firebaseStoragePath:
          "almanak/huizen/$huis/$year/thumbnails/picture${Thumbnail.x200}.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(minutes: 5),
    );

    return currentYearThumbnail == AssetImage(Images.placeholderProfilePicture)
        ? CachedImage.get(
            firebaseStoragePath:
                "almanak/huizen/$huis/${year - 1}/thumbnails/picture${Thumbnail.x200}.jpg",
            placeholderImagePath: Images.placeholderProfilePicture,
            maxAge: const Duration(minutes: 5),
          )
        : currentYearThumbnail;
  },
);
