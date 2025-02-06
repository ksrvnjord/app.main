import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This function is used to get a list of items in a folder. Does not have to be from the galery.
// ignore: prefer-static-class
final galleryFolderRef = FutureProvider.family<ListResult, String>((_, path) {
  return FirebaseStorage.instance.ref().child(path).listAll();
});

// ignore: prefer-static-class
final galleryFileUrlProvider = FutureProvider.family<String, String>((_, path) {
  return FirebaseStorage.instance.ref().child(path).getDownloadURL();
});
