import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseStorage store = FirebaseStorage.instance;

final galleryRootFolderRef = FutureProvider<ListResult>(
  (ref) => store.ref().child('galerij').listAll(),
);
