import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:universal_html/html.dart' as html;

Future<void> downloadAllProfilePictures({
  required void Function(bool isLoading, int downloaded, int total)
      onStateChanged,
}) async {
  final storage = FirebaseStorage.instance;

  // Get the root directory for 'forms/$docRef'
  final listResult = await storage.ref('people/').listAll();

  final total = listResult.prefixes.length;
  var downloaded = 0;

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
      if (fileRef.name != 'profile_picture.png') continue;

      // Download file as bytes
      final Uint8List? fileData = await fileRef.getData();
      if (fileData == null) continue;

      // Rename and add the file to the archive
      final fileName = "$userId.png";
      archive.addFile(ArchiveFile(fileName, fileData.length, fileData));

      onStateChanged(true, downloaded++, total);
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
      ..download = 'profile_pictures.zip'
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  onStateChanged(false, downloaded, total);
}
