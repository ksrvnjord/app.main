import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';

final bestuurPictureProvider =
    FutureProvider.family<ImageProvider<Object>, int>(
  (ref, year) {
    return CachedImage.get(
      firebaseStoragePath: "almanak/bestuur/$year/picture.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(days: 14),
    );
  },
);
