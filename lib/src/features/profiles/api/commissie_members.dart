import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

// ignore: prefer-static-class
final commissieLeedenProvider =
    StreamProvider.autoDispose.family<List<GroupDjangoRelation>, int>(
  (ref, id) async* {
    final dio = ref.watch(dioProvider);

    final res = await dio.get("/api/users/groups/$id/");

    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final users = (data['users'] as List)
        .map<GroupDjangoRelation>(
          (e) => GroupDjangoRelation.fromJson(e),
        )
        .toList();

    yield* Stream.value(users);
  },
);
