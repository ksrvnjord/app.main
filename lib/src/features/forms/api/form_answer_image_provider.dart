import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FormAnswerImageParams {
  FormAnswerImageParams({required this.docId, required this.userId});
  final String docId;
  final String userId;
}

final formAnswerImageProvider =
    FutureProvider.family<String?, FormAnswerImageParams>((ref, params) async {
  final String docId = params.docId;
  final String userId = params.userId;

  try {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('forms/$docId/$userId/thumbnails/image_200x200.png');

    final url = await storageRef.getDownloadURL().timeout(Duration(seconds: 5));
    return url;
  } on FirebaseException catch (e) {
    if (e.code == 'object-not-found') {
      // File does not exist, return null
      return null;
    } else {
      // Re-throw any other Firebase exceptions
      rethrow;
    }
  } catch (e) {
    // Handle any non-Firebase exceptions
    return null;
  }
});

class FormAnswerImageNotifier extends StateNotifier<AsyncValue<String?>> {
  FormAnswerImageNotifier() : super(const AsyncValue.loading());

  Future<void> addImage(
      String docId, String userId, Uint8List imageData) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('forms/$docId/thumbnails/${userId}_200x200.png');
      await ref.putData(imageData);
      final url = await ref.getDownloadURL();
      state = AsyncValue.data(url);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return;
    }
  }

  Future<void> changeImage(
      String docId, String userId, Uint8List imageData) async {
    await addImage(docId, userId, imageData);
  }
}

final formAnswerImageNotifierProvider =
    StateNotifierProvider<FormAnswerImageNotifier, AsyncValue<String?>>((ref) {
  return FormAnswerImageNotifier();
});
