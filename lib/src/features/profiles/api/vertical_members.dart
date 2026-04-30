import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ksrvnjord_main_app/src/features/admin/groups/models/django_group.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/substructures/model/group_django_relation.dart';
import 'package:ksrvnjord_main_app/src/features/shared/model/dio_provider.dart';

// ignore: prefer-static-class
final verticalLeedenProvider =
    StreamProvider.autoDispose.family<List<GroupDjangoRelation>, String>(
  (ref, name) async* {
    final dio = ref.watch(dioProvider);

    final res = await dio.get("/api/users/groups/", queryParameters: {
      "search": name,
    });

    /*
    Hey Finnn gebruik v2 aub, hieronder een voorbeeldje:

    
    final groupIdAsync = ref.watch(groupIDProvider(Tuple2(ploegName, year)));
    final users = groupIdAsync.when(
      data: (groupId) {
        if (groupId == null) {
          return const AsyncValue.data(<GroupDjangoRelation>[]);
        }
        return ref.watch(groupLeedenProvider(groupId));
      },
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
    );
    */

    final data = jsonDecode(res.toString()) as Map<String, dynamic>;
    final groups =
        (data['results'] as List).map((e) => DjangoGroup.fromJson(e)).toList();

    yield groups.firstOrNull?.users ?? [];
  },
);
