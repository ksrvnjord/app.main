import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/authentication/model/providers/firebase_auth_user_provider.dart';
import 'package:ksrvnjord_main_app/src/features/documents/api/documents_storage.dart';

// ignore: prefer-static-class
final documentUint8Provider =
    FutureProvider.autoDispose.family<Uint8List, String>((ref, path) async {
  // ignore: avoid-ignoring-return-values
  ref.watch(firebaseAuthUserProvider);

  final url = await ref.watch(documentsFileUrlProvider(path).future);

  // Download image from URL and return the image.
  final res = await Dio().get(
    url,
    options: Options(responseType: ResponseType.bytes),
  );

  return res.data;
});
