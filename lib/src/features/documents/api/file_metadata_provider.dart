import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
final fileMetadataProvider = FutureProvider.autoDispose
    .family<FullMetadata, Reference>((ref, path) async {
  return await path.getMetadata();
});
