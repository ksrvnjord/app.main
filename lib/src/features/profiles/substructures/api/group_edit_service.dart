import 'dart:io';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';

class GroupEditService {
  static Future<void> updateCommissieDescription({
    required String name,
    required String content,
    required int year,
    required int groupId,
  }) async {
    final filePath =
        '/almanak/commissies/$name/$year/$groupId/${name}Omschrijving.txt';
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
    required int groupId,
  }) async {
    final imagePath = '/almanak/commissie/$name/$year/$groupId/picture.jpg';
    final imageRef = FirebaseStorage.instance.ref(imagePath);

    try {
      await imageRef.putFile(image);
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }

  static Future<void> uploadVerticalImage({
    required String name,
    required File image,
  }) async {
    final imagePath = '/almanak/verticalen/$name/picture.jpeg';
    final imageRef = FirebaseStorage.instance.ref(imagePath);

    try {
      await imageRef.putFile(image);
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }
}
