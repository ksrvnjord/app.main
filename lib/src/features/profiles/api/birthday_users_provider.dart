import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/models/django_user.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

// ignore: prefer-static-class
Future<List<DjangoUser>> almanakBirthdayUsersProvider(
  int page,
  String search,
  WidgetRef ref,
) async {
  final dio = ref.watch(dioProvider);

  final res = await dio.get("/api/v2/users/", queryParameters: {
    "offset": page,
    "search": search,
    "is_birthdate": true,
  });

  final List<dynamic> data = jsonDecode(res.toString())['items'];

  return data.map((json) => DjangoUser.fromJson(json)).toList();
}
