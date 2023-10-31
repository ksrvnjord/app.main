// ignore_for_file: prefer-static-class
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/almanak_profile/model/group_django_entry.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

final commissiesForUserProvider =
    StreamProvider.autoDispose.family<List<GroupDjangoEntry>, String>(
  (ref, identifier) async* {
    final dio = ref.watch(dioProvider);
    final res = await dio.get("/api/users/users/", queryParameters: {
      "search": identifier,
    });
    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final results = data["results"] as List;
    final user = results.first as Map<String, dynamic>;

    final djangoId = user["id"] as int;
    final res2 = await dio.get("/api/users/users/$djangoId");
    final data2 = jsonDecode(res2.toString()) as Map<String, dynamic>;

    final commissies = (data2["groups"] as List)
        .map<GroupDjangoEntry>(
          (e) => GroupDjangoEntry.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    yield commissies;
  },
);
