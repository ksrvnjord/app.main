import 'dart:io';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';

class CommissieEditService {
  static Future<void> updateCommissieDescription({
    required String name,
    required String content,
    required int year,
  }) async {
    final filePath = '/almanak/commissies/$name/$year/${name}Omschrijving.txt';
    final storageRef = FirebaseStorage.instance.ref(filePath);

    try {
      // Upload the updated content as UTF-8 encoded bytes
      await storageRef.putData(utf8.encode(content));
    } catch (error) {
      throw Exception('Failed to update description: $error');
    }
  }

  static Future<void> uploadCommissieImage({
    required String name,
    required File image,
    required int year,
  }) async {
    final imagePath = '/almanak/commissies/$name/$year/picture.jpg';
    final imageRef = FirebaseStorage.instance.ref(imagePath);

    try {
      await imageRef.putFile(image);
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }
}
