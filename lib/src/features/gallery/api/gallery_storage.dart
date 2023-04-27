import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseStorage store = FirebaseStorage.instance;

final galleryFolderRef = FutureProvider.family<ListResult, String>((_, path) {
  return store.ref().child(path).listAll();
});

final galleryFile = FutureProvider.family<String, String>((_, path) {
  return store.ref().child(path).getDownloadURL();
});
