import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final allGroupsByYearProvider = FutureProvider.autoDispose
    .family<List<DjangoGroup>, Tuple2<String?, int>>((ref, typeAndYear) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get(
    "/api/v2/groups/",
    queryParameters: {
      "type": typeAndYear.item1?.toLowerCase(),
      "year": typeAndYear.item2,
      "ordering": "name",
    },
  );

  return (res.data['items'] as List).map<DjangoGroup>((e) {
    return DjangoGroup.fromJson(e);
  }).toList();
});

final allGroupsByOfficialNameProvider = FutureProvider.autoDispose
    .family<List<DjangoGroup>, String>((ref, officialName) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get(
    "/api/v2/groups/",
    queryParameters: {
      "search": officialName.toLowerCase(),
      "ordering": "name",
    },
  );

  return (res.data['items'] as List).map<DjangoGroup>((e) {
    return DjangoGroup.fromJson(e);
  }).toList();
});

// ignore: prefer-static-class
final groupByIdFutureProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, int>((ref, id) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get("/api/v2/groups/$id/");

  return res.data;
});

final groupByIdStreamProvider =
    StreamProvider.autoDispose.family<DjangoGroup, int?>(
  (ref, groupId) async* {
    if (groupId == null) {
      await Future<void>.delayed(const Duration(seconds: 1));
      throw ArgumentError.notNull('groupId');
    }
    final dio = ref.watch(dioProvider);

    final res = await dio.get("/api/v2/groups/$groupId");

    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final group = DjangoGroup.fromJson(data);

    yield group;
  },
);
