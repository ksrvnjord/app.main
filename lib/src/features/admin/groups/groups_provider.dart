import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/group_type.dart';
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

final allGroupsByTypeProvider = FutureProvider.autoDispose
    .family<List<DjangoGroup>, GroupType>((ref, type) async {
  final dio = ref.watch(dioProvider);
  final typeValue = type.value;
  final res = await dio.get(
    "/api/v2/groups/",
    queryParameters: {
      "type": typeValue.toLowerCase(),
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

// ignore: prefer-static-class
final verticalenProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>(
  (ref) async {
    final dio = ref.watch(dioProvider);
    final res = await dio.get("/api/v2/verticalen/");

    final items = (res.data['items'] as List? ?? const []);
    return items
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  },
);

// ignore: prefer-static-class
final verticalPloegenProvider =
    FutureProvider.autoDispose.family<List<DjangoGroup>, int>(
  (ref, verticaalId) async {
    final dio = ref.watch(dioProvider);
    final res = await dio.get(
      "/api/v2/verticalen/",
      queryParameters: {
        "type": "competitieploeg",
        "verticaal_id": verticaalId,
      },
    );

    return (res.data['results'] as List).map<DjangoGroup>((e) {
      return DjangoGroup.fromJson(e);
    }).toList();
  },
);

final ploegenProvider =
    FutureProvider.autoDispose.family<List<Map<String, dynamic>>, int>(
  (ref, verticaalId) async {
    final dio = ref.watch(dioProvider);
    final res = await dio.get(
      "/api/v2/verticalen/$verticaalId/ploegen",
      queryParameters: {
        "id": verticaalId,
      },
    );
    return List<Map<String, dynamic>>.from(res.data);
  },
);
