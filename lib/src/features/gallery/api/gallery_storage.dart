import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
final galleryFolderRef = FutureProvider.family<ListResult, String>((_, path) {
  return FirebaseStorage.instance.ref().child("galerij/$path").listAll();
});

// ignore: prefer-static-class
final galleryFileUrlProvider = FutureProvider.family<String, String>((_, path) {
  return FirebaseStorage.instance.ref().child(path).getDownloadURL();
});
