// ignore_for_file: prefer-static-class
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/thumbnail.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/group_id_provider.dart';
import 'package:tuple/tuple.dart';

final commissiePictureProvider = FutureProvider.autoDispose
    .family<ImageProvider<Object>, Tuple3<String, int, int>>(
  (ref, commissieAndYear) async {
    final commissie = commissieAndYear.item1;
    final year = commissieAndYear.item2;
    final groupId = commissieAndYear.item3;
    final currentYearPicture = await CachedImage.get(
      firebaseStoragePath:
          "almanak/commissies/$commissie/$year/$groupId/picture.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(minutes: 5),
    );
    if (currentYearPicture != AssetImage(Images.placeholderProfilePicture)) {
      return currentYearPicture;
    } else {
      final commissieAndYear = Tuple2(
        commissie,
        year - 1,
      );
      final prevGroupId =
          await ref.read(groupIDProvider(commissieAndYear).future);
      final prevPicture = await CachedImage.get(
        firebaseStoragePath:
            "almanak/commissies/$commissie/${year - 1}/$prevGroupId/picture.jpg",
        placeholderImagePath: Images.placeholderProfilePicture,
        maxAge: const Duration(seconds: 1),
      );
      return prevPicture;
    }
  },
);

final commissieThumbnailProvider = FutureProvider.autoDispose
    .family<ImageProvider<Object>, Tuple3<String, int, int>>(
  (ref, commissieAndYear) async {
    final commissie = commissieAndYear.item1;
    final year = commissieAndYear.item2;
    final groupId = commissieAndYear.item3;

    final currentYearThumbnail = await CachedImage.get(
      firebaseStoragePath:
          "almanak/commissies/$commissie/$year/$groupId/thumbnails/picture${Thumbnail.x200}.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(minutes: 5),
    );

    if (currentYearThumbnail != AssetImage(Images.placeholderProfilePicture)) {
      return currentYearThumbnail;
    } else {
      final commissieAndYear = Tuple2(
        commissie,
        year - 1,
      );
      final prevGroupId =
          await ref.read(groupIDProvider(commissieAndYear).future);
      final prevThumbnail = await CachedImage.get(
        firebaseStoragePath:
            "almanak/commissies/$commissie/${year - 1}/$prevGroupId/thumbnails/picture${Thumbnail.x200}.jpg",
        placeholderImagePath: Images.placeholderProfilePicture,
        maxAge: const Duration(minutes: 5),
      );
      return prevThumbnail;
    }
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
