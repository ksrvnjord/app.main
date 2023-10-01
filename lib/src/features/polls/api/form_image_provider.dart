import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
final formImageProvider = FutureProvider.family<Uint8List?, String>((_, path) {
  return FirebaseStorage.instance.ref().child(path).getData();
});
