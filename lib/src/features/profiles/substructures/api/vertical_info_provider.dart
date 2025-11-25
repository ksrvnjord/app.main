import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';

// A provider that fetches the substructure info for a given substructure name from firebase
Future<String?> fetchDescription(String name) async {
  final filePath = '/almanak/verticals/$name/${name}Omschrijving.txt';
  final storageRef = FirebaseStorage.instance.ref(filePath);
  try {
    final data = await storageRef.getData();
    if (data != null) {
      return utf8.decode(data);
    } else {
      throw Exception("Geen omschrijving gevonden.");
    }
  } catch (error) {
    return null;
  }
}

// ignore: prefer-static-class
final verticalDescriptionProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, vertical) async {
  return await fetchDescription(vertical);
});
