import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:tuple/tuple.dart';

final groupIDProvider = FutureProvider.autoDispose
    .family<int?, Tuple2<String, int>>((ref, nameAndYear) async {
  final dio = ref.watch(dioProvider);

  final res = await dio.get("/api/users/groups/", queryParameters: {
    "search": nameAndYear.item1,
    "year": nameAndYear.item2,
  });

  final data = jsonDecode(res.toString()) as Map<String, dynamic>;
  final groups =
      (data['results'] as List).map((e) => DjangoGroup.fromJson(e)).toList();

  return groups.firstOrNull?.id;
});
