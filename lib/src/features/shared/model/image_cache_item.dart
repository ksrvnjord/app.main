import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'image_cache_item.g.dart';

@HiveType(typeId: 0)
class ImageCacheItem extends HiveObject {
  @HiveField(0)
  final Uint8List? data;

  @HiveField(1)
  final DateTime expire;
  // ignore: sort_constructors_first
  ImageCacheItem({
    required this.data,
    required this.expire,
  });
}
