// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_cache_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageCacheItemAdapter extends TypeAdapter<ImageCacheItem> {
  @override
  final int typeId = 0;

  @override
  ImageCacheItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageCacheItem(
      data: fields[0] as Uint8List?,
      expire: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ImageCacheItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.expire);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageCacheItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
