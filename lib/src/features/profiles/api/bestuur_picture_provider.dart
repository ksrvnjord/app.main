import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';
import 'package:tuple/tuple.dart';

final bestuurPictureProvider =
    FutureProvider.autoDispose.family<ImageProvider<Object>, Tuple2<int, bool>>(
  (ref, items) {
    final year = items.item1;
    final thumbnail = items.item2;

    return CachedImage.get(
      firebaseStoragePath: "almanak/bestuur/$year/picture.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(days: 14),
      thumbnail: thumbnail,
    );
  },
);
