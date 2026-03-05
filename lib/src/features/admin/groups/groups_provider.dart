import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final groupsProvider = FutureProvider.autoDispose
    .family<List<DjangoGroup>, Tuple2<String?, int>>((ref, typeAndYear) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get(
    "/api/users/groups/",
    queryParameters: {
      "type": typeAndYear.item1?.toLowerCase(),
      "year": typeAndYear.item2,
      "ordering": "name",
    },
  );

  return (res.data['results'] as List).map<DjangoGroup>((e) {
    return DjangoGroup.fromJson(e);
  }).toList();
});

// ignore: prefer-static-class
final groupByIdProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, int>((ref, id) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get("/api/v2/groups/$id/");

  return res.data;
});

// ignore: prefer-static-class
final verticalsProvider = FutureProvider.autoDispose
    .family<List<DjangoGroup>, String>((ref, type) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get(
    "/api/users/groups/",
    queryParameters: {
      "type": type.toLowerCase(),
      "ordering": "name",
    },
  );

  return (res.data['results'] as List).map<DjangoGroup>((e) {
    return DjangoGroup.fromJson(e);
  }).toList();
});

final ploegenProvider =
    FutureProvider.autoDispose.family<List<Map<String, dynamic>>, int>(
  (ref, verticaalId) async {
    final dio = ref.watch(dioProvider);
    final res = await dio.get(
      "/api/v2/groups/$verticaalId/ploegen",
    );
    return List<Map<String, dynamic>>.from(res.data);
  },
);
