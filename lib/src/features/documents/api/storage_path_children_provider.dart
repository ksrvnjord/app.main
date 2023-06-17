import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
final storagePathChildrenProvider =
    FutureProvider.family<ListResult, Reference>(
  (ref, reference) async {
    return await reference.listAll();
  },
);
