import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
final assetStringProvider =
    FutureProvider.family<String, String>((ref, assetPath) async {
  return await rootBundle.loadString(assetPath);
});
