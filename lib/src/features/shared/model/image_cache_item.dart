import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'image_cache_item.g.dart';

@HiveType(typeId: 0)
class ImageCacheItem extends HiveObject {
  ImageCacheItem({
    required this.data,
    required this.expire,
  });

  @HiveField(0)
  final Uint8List? data;

  @HiveField(1)
  final DateTime expire;
}
