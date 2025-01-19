// ignore_for_file: unused_result

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

final storage = FirebaseStorage.instance;

// Class for holding parameters
class FormAnswerImageParams {
  FormAnswerImageParams({required this.docId, required this.userId});

  final String docId;
  final String userId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormAnswerImageParams &&
        other.docId == docId &&
        other.userId == userId;
  }

  @override
  int get hashCode => docId.hashCode ^ userId.hashCode;
}

// Fetch image function
Future<String> fetchImage(String docRef, String userId) async {
  return await storage
      .ref('testforms/$docRef/$userId/image.png')
      .getDownloadURL();
}

Future<bool> addImage(Uint8List image, String docRef, WidgetRef ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    await storage
        .ref('testforms/$docRef/${user.identifierString}/image.png')
        .putData(image);
    ref.refresh(myFormAnswerImageProvider(docRef));
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> changeImage(Uint8List image, String docRef, WidgetRef ref) async {
  return await addImage(image, docRef, ref);
}

Future<bool> deleteImage(String docRef, WidgetRef ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    await storage
        .ref('testforms/$docRef/${user.identifierString}/image.png')
        .delete();
    ref.refresh(myFormAnswerImageProvider(docRef));
    return true;
  } catch (e) {
    return false;
  }
}

// Provider for form anser of current user
final myFormAnswerImageProvider =
    FutureProvider.family<String, String>((ref, docId) async {
  final user = await ref.watch(currentUserProvider.future);
  final params =
      FormAnswerImageParams(docId: docId, userId: user.identifierString);
  return fetchImage(params.docId, params.userId);
});

// Provider for form anser of other user
final formAnswerImageProvider =
    FutureProvider.family<String, FormAnswerImageParams>((ref, params) async {
  return fetchImage(params.docId, params.userId);
});
