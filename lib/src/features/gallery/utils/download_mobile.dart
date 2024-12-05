import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:share_plus/share_plus.dart';

// ignore: prefer-static-class
void downloadImageForMobile(Uint8List imageBytes, int currentPage) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/foto_$currentPage.jpg';
  final xFile = XFile.fromData(imageBytes, mimeType: 'image/jpeg');
  await xFile.saveTo(filePath);
}
