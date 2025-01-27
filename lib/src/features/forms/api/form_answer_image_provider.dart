// ignore_for_file: unused_result

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

final storage = FirebaseStorage.instance;

// Class for holding parameters
class FormAnswerImageParams {
  FormAnswerImageParams({
    required this.docId,
    required this.userId,
    required this.questionName,
  });
  final String docId;
  final String userId;
  final String questionName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormAnswerImageParams &&
        other.docId == docId &&
        other.userId == userId &&
        other.questionName == questionName;
  }

  @override
  int get hashCode => docId.hashCode ^ userId.hashCode ^ questionName.hashCode;
}

// Fetch image function
Future<String> fetchImage(
    String docRef, String userId, String questionName) async {
  return await storage
      .ref('testforms/$docRef/$userId/$questionName.png')
      .getDownloadURL();
}

Future<bool> addImage(
    Uint8List image, String docRef, String questionName, WidgetRef ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    await storage
        .ref('testforms/$docRef/${user.identifierString}/$questionName.png')
        .putData(image);
    ref.refresh(formAnswerImageProvider(FormAnswerImageParams(
        docId: docRef,
        userId: user.identifierString,
        questionName: questionName)));
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> changeImage(
    Uint8List image, String docRef, String questionName, WidgetRef ref) async {
  return await addImage(image, docRef, questionName, ref);
}

Future<bool> deleteImage(
    String docRef, String questionName, WidgetRef ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    await storage
        .ref('testforms/$docRef/${user.identifierString}/$questionName.png')
        .delete();
    ref.refresh(formAnswerImageProvider(FormAnswerImageParams(
        docId: docRef,
        userId: user.identifierString,
        questionName: questionName)));
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteAllImages(String docRef, WidgetRef ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    final listResult = await storage
        .ref('testforms/$docRef/${user.identifierString}')
        .listAll();

    for (var item in listResult.items) {
      await item.delete();
    }
    ref.invalidate(formAnswerImageProvider);

    return true;
  } catch (e) {
    return false;
  }
}

// Provider for form anser of other user
final formAnswerImageProvider =
    FutureProvider.family<String, FormAnswerImageParams>((ref, params) async {
  return fetchImage(params.docId, params.userId, params.questionName);
});
