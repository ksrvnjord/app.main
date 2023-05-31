import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/cached_image.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final huisPictureProvider = FutureProvider.autoDispose
    .family<ImageProvider<Object>, Tuple2<String, int>>(
  (ref, huisAndYear) {
    final huis = huisAndYear.item1;
    final year = huisAndYear.item2;

    return CachedImage.get(
      firebaseStoragePath: "almanak/huizen/$huis/$year/picture.jpg",
      placeholderImagePath: Images.placeholderProfilePicture,
      maxAge: const Duration(days: 14),
    );
  },
);
