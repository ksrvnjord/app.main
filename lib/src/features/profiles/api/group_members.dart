import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

// ignore: prefer-static-class
final groupLeedenProvider =
    StreamProvider.autoDispose.family<List<GroupDjangoRelation>, int>(
  (ref, groupId) async* {
    final dio = ref.watch(dioProvider);

    final res = await dio.get("/api/v2/groups/$groupId");

    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final group = DjangoGroup.fromJson(data);

    yield group.users ?? [];
  },
);
