import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:universal_html/html.dart' as html;

Future<void> downloadAllProfilePictures({
  required void Function(bool isLoading, int downloaded, int total)
      onStateChanged,
      int batchSize = 600,
}) async {
  final storage = FirebaseStorage.instance;

  // Get the root directory for 'forms/$docRef'
  final listResult = await storage.ref('people/').listAll();


  final folders = listResult.prefixes.where((f) => f.name != "thumbnails").toList();
  final total = folders.length;
  var downloaded = 0;
  var batchNum = 0;

  // Initialize an in-memory zip archive
  var archive = Archive();

  Future<void> flushBatch() async {
    if (archive.files.isEmpty) return;

    // Encode the archive to a zip file
    final zipData = ZipEncoder().encode(archive);

    if (zipData != null) {
      // Create a Blob and trigger a download
      final blob = html.Blob([zipData]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      // ignore: unused_local_variable
      final anchor = html.AnchorElement(href: url)
        ..download = 'profile_pictures_part${batchNum + 1}.zip'
        ..click();
      html.Url.revokeObjectUrl(url);
    }
    batchNum++;
    archive = Archive();
  }

  for (final folder in folders) {
    final userId = folder.name;

    try {
      // List files in the userId folder
      final userFolderResult = await folder.listAll();

      for (final fileRef in userFolderResult.items) {
        // Skip any thumbnails folder in the second layer
        if (fileRef.name != 'profile_picture.png') continue;

        // Download file as bytes
        final Uint8List? fileData = await fileRef.getData();
        if (fileData == null) continue;

        archive.addFile(ArchiveFile(fileName(userId), fileData.length, fileData));
      }
    }
    catch (e) {
      print('Failed for $userId $e');
      continue;
    }

    onStateChanged(true, downloaded++, total);
    if (downloaded % batchSize == 0) {
      await flushBatch();
    }
  }

  // Flush partial batch
  await flushBatch();
  onStateChanged(false, downloaded, total);
}

String fileName(String userId) => '$userId.png';
