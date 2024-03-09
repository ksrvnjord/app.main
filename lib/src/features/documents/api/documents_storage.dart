import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';

// ignore: prefer-static-class
final documentsFolderRef =
    FutureProvider.autoDispose.family<ListResult, String>((ref, path) {
  return FirebaseStorage.instance.ref().child(path).listAll();
});

// ignore: prefer-static-class
final documentsFileUrlProvider =
    FutureProvider.autoDispose.family<String, String>((ref, path) {
  // ignore: avoid-ignoring-return-values
  ref.watch(firebaseAuthUserProvider);

  return FirebaseStorage.instance.ref().child(path).getDownloadURL();
});
