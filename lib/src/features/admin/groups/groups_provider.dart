import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';
import 'package:tuple/tuple.dart';

// ignore: prefer-static-class
final groupsProvider = FutureProvider.autoDispose
    .family<List, Tuple2<String?, int>>((ref, typeAndYear) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get(
    "/api/users/groups/",
    queryParameters: {
      "type": typeAndYear.item1,
      "year": typeAndYear.item2,
      "ordering": "name",
    },
  );

  return res.data['results'];
});

// ignore: prefer-static-class
final groupByIdProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, int>((ref, id) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get("/api/users/groups/$id/");

  return res.data;
});
