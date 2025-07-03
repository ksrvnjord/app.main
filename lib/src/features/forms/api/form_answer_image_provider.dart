// ignore_for_file: unused_result

import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:archive/archive.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/forms/model/firestore_form.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

import 'package:universal_html/html.dart' as html;

final storage = FirebaseStorage.instance;

// Class for holding parameters
class FormAnswerImageParams {
  FormAnswerImageParams({
    required this.docId,
    required this.userId,
    required this.questionId,
  });
  final String docId;
  final String userId;
  final String questionId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormAnswerImageParams &&
        other.docId == docId &&
        other.userId == userId &&
        other.questionId == questionId;
  }

  @override
  int get hashCode => docId.hashCode ^ userId.hashCode ^ questionId.hashCode;
}

// Fetch image function
Future<String> fetchImage(
    String docRef, String userId, String questionId) async {
  return await storage
      .ref('$firestoreFormCollectionName/$docRef/$userId/$questionId.png')
      .getDownloadURL();
}

Future<bool> addImage(
    Uint8List image, String docRef, String questionId, WidgetRef ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    await storage
        .ref(
            '$firestoreFormCollectionName/$docRef/${user.identifierString}/$questionId.png')
        .putData(image);
    ref.refresh(formAnswerImageProvider(FormAnswerImageParams(
        docId: docRef,
        userId: user.identifierString,
        questionId: questionId)));
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> changeImage(
    Uint8List image, String docRef, String questionId, WidgetRef ref) async {
  return await addImage(image, docRef, questionId, ref);
}

Future<bool> deleteImage(
    String docRef, String questionId, WidgetRef ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    await storage
        .ref(
            '$firestoreFormCollectionName/$docRef/${user.identifierString}/$questionId.png')
        .delete();
    ref.refresh(formAnswerImageProvider(FormAnswerImageParams(
        docId: docRef,
        userId: user.identifierString,
        questionId: questionId)));
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteAllImages(String docRef, WidgetRef ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    final listResult = await storage
        .ref('$firestoreFormCollectionName/$docRef/${user.identifierString}')
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

Future<void> downloadAllFormImageAnswers(String docRef) async {
  final storage = FirebaseStorage.instance;

  // Get the root directory for 'forms/$docRef'
  final listResult =
      await storage.ref('$firestoreFormCollectionName/$docRef').listAll();

  // Initialize an in-memory zip archive
  final archive = Archive();

  for (var folder in listResult.prefixes) {
    final userId = folder.name;

    // Skip folders named 'thumbnails'
    if (userId == 'thumbnails') continue;

    // List files in the userId folder
    final userFolderResult = await folder.listAll();
    for (var fileRef in userFolderResult.items) {
      // Skip any thumbnails folder in the second layer
      if (fileRef.fullPath.contains('/thumbnails/')) continue;

      // Download file as bytes
      final Uint8List? fileData = await fileRef.getData();
      if (fileData == null) continue;

      // Rename and add the file to the archive
      final fileName = '${userId}_${fileRef.name}';
      archive.addFile(ArchiveFile(fileName, fileData.length, fileData));
    }
  }

  // Encode the archive to a zip file
  final zipData = ZipEncoder().encode(archive);

  if (zipData != null) {
    // Create a Blob and trigger a download
    final blob = html.Blob([zipData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    // ignore: unused_local_variable
    final anchor = html.AnchorElement(href: url)
      ..download = '$docRef.zip'
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}

// Provider for form anser of other user
final formAnswerImageProvider =
    FutureProvider.family<String, FormAnswerImageParams>((ref, params) async {
  return fetchImage(params.docId, params.userId, params.questionId);
});
