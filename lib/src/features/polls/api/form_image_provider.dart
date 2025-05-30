import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Use this logic for future image inclusion of forms

// ignore: prefer-static-class
final formImageProvider =
    FutureProvider.autoDispose.family<Uint8List?, String>((ref, path) {
  return FirebaseStorage.instance.ref().child(path).getData();
});
