import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

// ignore: prefer-static-class
Future<Map<String, dynamic>> almanakUsers(
  int page,
  String search,
  WidgetRef ref,
) async {
  final dio = ref.watch(dioProvider);

  final res = await dio.get("/api/users/users/", queryParameters: {
    "page": page,
    "search": search,
  });

  return jsonDecode(res.toString()) as Map<String, dynamic>;
}
