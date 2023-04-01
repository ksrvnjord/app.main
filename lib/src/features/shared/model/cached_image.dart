import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:ksrvnjord_main_app/assets/images.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/hive_cache.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/image_cache_item.dart';

abstract class CachedImage {
  final String cachingKey = '';
  final String imagePathOnNoData = Images.placeholderProfilePicture;

  Future<ImageProvider<Object>> get(String name);
}

class SubstructureImage implements CachedImage {
  @override
  final String cachingKey = 'substructure-image-';

  @override
  final String imagePathOnNoData = Images.placeholderProfilePicture;

  @override
  Future<ImageProvider<Object>> get(String name) async {
    final cachingKey = this.cachingKey + name;
    ImageProvider<Object>? image = await HiveCache.getHiveCachedImage(
      cachingKey,
      imageOnCacheHitWithNoData: Image.asset(imagePathOnNoData).image,
    );
    if (image != null) {
      return image;
    }

    // retrieve the image from the internet
    Uint8List? imageBytes = await HiveCache.getHttpImageAndCache(
      'https://picsum.photos/250?image=9',
      key: cachingKey,
    );
    if (imageBytes == null) {
      return Image.asset(imagePathOnNoData).image;
    }

    return MemoryImage(imageBytes);
  }
}
